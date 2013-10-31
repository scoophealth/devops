#!/bin/bash
#
set -e # exit on errors
#
cd $HOME
#
if [ -f ".bash_profile" ]
then
  source ~/.bash_profile
else
  echo "Run setup-base.sh before running this script."
  exit
fi
#
echo "Setting up endpoint (query-gateway) software"
if [ ! -d endpoint ]
then
  mkdir endpoint
fi
cd endpoint
git clone git://github.com/scoophealth/query-gateway.git
cd query-gateway
bundle install
bundle exec rake db:seed
bundle exec rake test
if [ ! -d tmp/pids ]
then
  mkdir -p tmp/pids
fi
#
echo "Setting up hub (query-composer) software"
cd $HOME
if [ ! -d hub ]
then
  mkdir hub
fi
cd hub
git clone git://github.com/scoophealth/query-composer.git
cd query-composer
bundle install
bundle exec rake db:seed
bundle exec rake test
