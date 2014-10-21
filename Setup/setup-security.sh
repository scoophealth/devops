#!/bin/bash
#
set -e # exit on errors
#
### 1) Don't write command history to disk
# Based on discussion at 
# http://www.cyberciti.biz/faq/clear-the-shell-history-in-ubuntu-linux/
#
# Clear bash shell history
history -c
# Remove history file
if [ -f ~/.bash_history ]
then
  rm ~/.bash_history
fi
# Add 'history -c' to end of ~/.bash_logout
touch ~/.bash_logout # create ~/.bash_logout if it doesn't exist
if ! grep --quiet "history -c" ~/.bash_logout; then
  echo 'history -c' >> ~/.bash_logout
fi
# Modify HISTFILE and LESSHISTFILE to prevent history file creation
if ! grep --quiet "unset HISTFILE" ~/.bashrc; then
  echo 'unset HISTFILE' >> ~/.bashrc
fi
if ! grep --quiet "export LESSHISTFILE" ~/.bashrc; then
  echo 'export LESSHISTFILE="-"' >> ~/.bashrc
fi
#
### 2) Configure firewall
# From https://help.ubuntu.com/lts/serverguide/firewall.html
# and https://wiki.ubuntu.com/UncomplicatedFirewall
#
sudo ufw allow 22
sudo ufw limit 22
sudo ufw enable
sudo ufw status verbose
#
### 3) Don't start Tomcat automatically since Oscar properties are kept
# in an encypted filesystem.  Tomcat6 needs to be started manually after
# the filesystem is unlocked.
if [ -f /etc/rc5.d/S92tomcat6 ]
then
  sudo rm /etc/rc?.d/S92tomcat6
fi
#
### 4) Don't start mongodb automatically during server startup since the
# mongodb database is stored in an encrypted filesystem.  Comment out the start on
# runlevel line but leave the stop on runlevel so the database is shut down
# gracefully during system shutdown, reducing the likelihood of database corruption.
sudo sed --in-place "s/start on runlevel/#start on runlevel/" /etc/init/mongodb.conf
#
### 5) The query-gateway cannot start until the mongodb database filesystem
# has the encryption password entered manually so unmonitor query-gateway
# before monit is shutdown during system shutdown or reboot.  This string
# subsitution adds a line to unmonitor query-gateway in the stop) section
# of /etc/init.d/monit.  This is needed because the monitoring state is
# persistent across Monit restarts
sudo sed --in-place "/stop)/{G;s/$/    \/usr\/bin\/monit unmonitor query-gateway/;}" /etc/init.d/monit
#
### 6) Move mongodb database to an encrypted filesystem.
# First quit monitoring query-gateway, stop monit, then gateway software
# and mongodb:
if [ ! -d /encrypted ]
then
  sudo monit unmonitor query-gateway
  sudo /etc/init.d/monit stop
  $HOME/bin/stop-endpoint.sh
  sudo service mongodb stop
  # Move mongodb to encrypted filesystem
  echo "You need to set up passphrase now"
  sudo encfs --public /.encrypted /encrypted
  sudo rsync -av /var/lib/mongodb /encrypted
  sudo chmod a+rx /encrypted
  sudo chmod a+rx /.encrypted
  if [ ! -d /encrypted/mongodb ]
  then
    echo "Error occurred moving mongodb to encrypted filesystem"
    exit
  fi
  sudo sed --in-place "s/\/var\/lib\/mongodb/\/encrypted\/mongodb/" /etc/mongodb.conf
  sudo /etc/init.d/monit start
  cd ~/endpoint/query-gateway
  sudo mv log /encrypted/endpoint-log
  sudo ln -s /encrypted/endpoint-log ./log
  echo "sudo /usr/bin/encfs --public /.encrypted /encrypted && sudo initctl start mongodb && sudo monit start query-gateway" > $HOME/start-encfs-mongo-endpoint
  cd $HOME
  chmod a+x ./start-encfs-mongo-endpoint
fi
#
### 6) Move the oscar properties file to the encrypted filesystem
if [ -f $CATALINA_HOME/oscar12.properties ]
then
  if [ ! -h $CATALINA_HOME/oscar12.properties ]
  then
    cd $CATALINA_HOME
    sudo mkdir /encrypted/oscar
    sudo mv oscar12.properties /encrypted/oscar
    sudo ln -s /encrypted/oscar/oscar12.properties ./oscar12.properties
  fi
fi
echo
echo "IMPORTANT: Do not forget the encfs password. If you wish to change"
echo "it use the 'encfsctl' command.  The syntax looks like this:"
echo "     sudo encfsctl passwd /.encrypted"
