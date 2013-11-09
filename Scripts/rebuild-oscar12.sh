#!/bin/bash
#
set -e # Exit on errors
#
# In case we want to run this from monit set up environment correctly
HOME=/home/scoopadmin
source $HOME/.bashrc
if [ -z "$CATALINA_BASE" ]
then
  echo "Environment variable CATALINA_HOME is not set.  Exiting..."
  exit
fi
#
if [ ! -d $HOME/emr/oscar ]
then
  echo "No Oscar source found.  Exiting..."
  exit
fi
# Stop tomcat while redeploying Oscar
sudo /etc/init.d/tomcat6 stop
# Update to latest scoop-deploy build
cd $HOME/emr/oscar
git fetch origin
git checkout scoop-deploy
git reset --hard origin/scoop-deploy
# Build Oscar from source
export CATALINA_HOME
mvn -Dmaven.test.skip=true clean verify
# Clean out old oscar deployment
sudo rm -rf $CATALINA_BASE/webapps/oscar12
sudo rm $CATALINA_BASE/webapps/oscar12.war
# Copy over new oscar war file
sudo cp ./target/*.war $CATALINA_BASE/webapps/oscar12.war
# build oscar_documents from source
if [ ! -d $HOME/emr/oscar_documents ]
then
  echo "No Oscar_documents found."
else
  cd $HOME/emr/oscar_documents
  git pull
  mvn -Dmaven.test.skip=true clean package
  sudo cp ./target/*.war $CATALINA_BASE/webapps/OscarDocument.war
fi
# Restart Tomcat
sudo /etc/init.d/tomcat6 start
