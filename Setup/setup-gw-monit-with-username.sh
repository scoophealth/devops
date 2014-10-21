#!/bin/bash
#
set -e # exit on errors
#
if [ $# -gt 1 ]
then
  echo "Usage: $0 username"
  echo " * Note: username is the account that owns the query-gateway process."
  echo " * If omitted username defaults to 'scoopadmin'"
  exit
fi
USERNAME='scoopadmin' 
if [ $# -eq 1 ]
then
  USERNAME="$1"
fi
export USERNAME
if [ ! -d $HOME/devops/tmp ]
then
  mkdir $HOME/devops/tmp
fi
sed "s/scoopadmin/$USERNAME/g" $HOME/devops/Setup/setup-gateway-monit.sh > $HOME/devops/tmp/setup-gateway-monit-with-subs-username.sh
if [ -f $HOME/devops/tmp/setup-gateway-monit-with-subs-username.sh ]
then
  chmod u+x $HOME/devops/tmp/setup-gateway-monit-with-subs-username.sh
  sudo $HOME/devops/tmp/setup-gateway-monit-with-subs-username.sh
else
  echo "Failed to run string subsitution on $HOME/devops/Setup/setup-gateway-monit.sh"
  exit
fi
sudo monit status verbose
