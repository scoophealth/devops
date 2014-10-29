#!/bin/bash
#
set -e # exit on errors
#
# bring OS up to date
sudo apt-get --yes update
sudo apt-get --yes upgrade
#

# install some basic packages
sudo apt-get --yes install ntp  # use ntpdate if clock skew is large
sudo apt-get --yes install git curl

# install libraries needed by scoophealth software
sudo apt-get --yes install libxslt-dev libxml2-dev
#
# some other useful packages (Note: screen and script are installed
# in Ubuntu server by default but if they are missing install them);
# handle packages separately in case some are no longer in repo
sudo apt-get --yes install lynx-cur
sudo apt-get --yes install tshark
sudo apt-get --yes install screen
(sudo apt-get --yes install script) || true # make this not error out
sudo apt-get --yes install autossh
sudo apt-get --yes install monit
sudo apt-get --yes install encfs
#
# make sure command-history editing works, may not be needed for Ubuntu 14.04
cat >> ~/.bashrc <<'EOF'
#
#http://askubuntu.com/questions/41891/bash-auto-complete-for-environment-variables/
shopt -s direxpand
EOF
#
##
## add some git aliases
##
if [ ! -f $HOME/.gitconfig ]
then
  cat > $HOME/.gitconfig << 'EOF'
[alias]
  co = checkout
  ci = commit
  st = status
  br = branch
  lg = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
  type = cat-file -t
  dump = cat-file -p
EOF
fi
#
# Provide example of how to configure a static virtual interface to fall
# back to if dhcp fails
##
sudo bash -c "cat >> /etc/network/interfaces" <<'EOF'

## Template for adding static virtual interface.
## Uncomment the following lines and modify as
## needed to create a static virtual interface.
## For Ubuntu 12.04 leave gateway commented out.
#auto eth0:0
#iface eth0:0 inet static
#  address 192.168.4.205
#  netmask 255.255.255.0
##  gateway 192.168.4.1
EOF
#
# Speed up ssh login connections to server
##
if ! grep --quiet "UseDNS no" /etc/ssh/sshd_config
then
  # don't indent here document below
  sudo bash -c "cat >> /etc/ssh/sshd_config" <<'EOF'

# Added to speed up login (Raymond Rusk, Scoophealth)
UseDNS no
EOF
#
fi
#
# set up Oracle Java 6 or 7 (problems with Oscar 12 and Java 7 so use 6 instead)
# http://www.webupd8.org/2012/11/oracle-sun-java-6-installer-available.html
# http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html
sudo apt-get --yes install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get --yes update
sudo apt-get --yes install oracle-java6-installer
#sudo apt-get --yes install oracle-java7-installer

# set up OpenJDK Java 7 (no headless version, installs many GUI packages)
#sudo apt-get install openjdk-7-jdk

#
# set up mongod
# http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get --yes update
sudo apt-get --yes install mongodb-org
#
cd $HOME
# set up ruby and rails
if [ ! -d ".rvm" ]
then
  # a key now seems required (as of Oct 29, 2014)
  gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
  curl -L https://get.rvm.io | bash -s stable
  if [ ! ~/.bash_profile ]
  then
    echo 'source ~/.profile' >> ~/.bash_profile
  fi
  #source ~/.bash_profile
  source $HOME/.rvm/scripts/rvm
  rvm requirements
  rvm install 1.9.3
  rvm use 1.9.3 --default
  rvm rubygems current
  gem install bundler
  gem install rails
fi
#
echo
echo "Use 'sudo vi /etc/resolvconf/resolv.conf.d/head' to add specific nameservers to"
echo "/etc/resolv.conf for DNS lookups.  For instance, add the line"
echo "'nameserver 142.104.6.1' to use UVic's main name service."
