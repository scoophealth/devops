#!/bin/bash

#set -e # exit on errors

if ! grep --quiet "UseDNS no" /etc/ssh/sshd_config
then
  # don't indent here document below
  sudo bash -c "cat >> /etc/ssh/sshd_config" <<'EOF'
#
# Added to speed up login (Raymond Rusk, Scoophealth)
UseDNS no
EOF
fi

# install basic packages
sudo apt-get --yes install git curl ntp  # use ntpdate if clock skew is large

# set up mongod
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get --yes update
sudo apt-get --yes install mongodb-10gen

cd $HOME
# set up ruby and rails
if [ ! -d ".rvm" ]
then
  curl -L https://get.rvm.io | bash -s stable
  echo 'source ~/.profile' >> ~/.bash_profile
  source ~/.bash_profile
  #source /etc/profile.d/rvm.sh
  rvm requirements
  rvm install 1.9.3
  rvm use 1.9.3 --default
  rvm rubygems current
  gem install bundler
  gem install rails
fi

# intstall libraries needed by scoophealth software
sudo apt-get --yes install libxslt-dev libxml2-dev

# other useful packages (Note: screen and script are installed
# in Ubuntu server by default; if they are missing install them)
# handle packages separately in case some are no longer in repo

sudo apt-get --yes install lynx-cur tshark screen autossh monit encfs
(sudo apt-get --yes install script) || true # make this not error out

#cat >> ~/.bashrc <<'EOF'
#
#http://askubuntu.com/questions/41891/bash-auto-complete-for-environment-variables/
#shopt -s direxpand
#EOF

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

echo "Fetching scoophealth devops"
cd $HOME
if [ ! -d devops ]
then
  git clone https://github.com/scoophealth/devops.git
fi

echo "Setting up endpoint (query-gateway) software"
if [ ! -d endpoint ]
then
  mkdir endpoint
fi

cd endpoint
if [ ! -d query-gateway ]
then
  git clone git://github.com/scoophealth/query-gateway.git
fi
cd query-gateway
bundle install
#bundle exec rake db:seed
#bundle exec rake test
if [ ! -d tmp/pids ]
then
  mkdir -p tmp/pids
fi
#./setup-gateway-monit.sh

echo ""
echo "Vagrant Endpoint Instance Provisioned - log in to boot query-gateway manually"
