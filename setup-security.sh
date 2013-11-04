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
# mongodb database is stored in an encrypted filesystem.
sudo sed --in-place "s/start on runlevel/#start on runlevel/" /etc/init/mongodb.conf
#
### 5) The query-gateway cannot start until the mongodb database filesystem
# has the encryption password entered manually so unmonitory query-gateway
# before monit is shutdown during system shutdown or reboot
sudo sed --in-place "/stop)/{G;s/$/    \/usr\/bin\/monit unmonitor query-gateway/;}" /etc/init.d/monit
