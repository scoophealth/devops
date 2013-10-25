#!/bin/bash
#
# in case we want to run this from monit set up environment correctly
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
sudo /etc/init.d/tomcat6 stop
cd $HOME/emr/oscar
git checkout scoop-deploy
git pull
#
# build Oscar from source
export CATALINA_HOME
mvn -Dmaven.test.skip=true verify
# stop tomcat while redeploying Oscar
sudo cp ./target/*.war $CATALINA_BASE/webapps/oscar12.war
#
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
#
# restart tomcat
sudo /etc/init.d/tomcat6 start
#
