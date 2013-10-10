#!/bin/bash
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
cd $HOME
if [ ! -d hub ]
  mkdir hub
fi
cd hub
git clone git://github.com/scoophealth/query-composer.git
cd query-composer
bundle install
bundle exec rake db:seed
bundle exec rake test
