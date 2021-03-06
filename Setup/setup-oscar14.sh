#!/bin/bash
#
set -e # exit on errors
#
echo -n "Enter Oscar password: "
read oscar_passwd
echo "Create Oscar database with password $oscar_passwd"
#

cd $HOME
# install MySQL
if [ ! -d /var/lib/mysql ]
then
  sudo apt-get --yes install mysql-server libmysql-java
fi
#
# setup JAVA_HOME
if ! grep --quiet "JAVA_HOME" /etc/environment
then
  sudo bash -c 'echo JAVA_HOME=\"/usr/lib/jvm/java-6-oracle\" >> /etc/environment'
fi
export JAVA_HOME="/usr/lib/jvm/java-6-oracle"
#
# install Tomcat and Maven
if ! grep --quiet "CATALINA_BASE" /etc/environment
then
  sudo apt-get --yes install tomcat6 maven git-core
  #
  # set up Tomcat's deployment environment
  # Do not indent body of HERE document!
  sudo bash -c "cat  >> /etc/environment" <<'EOF'
CATALINA_HOME="/usr/share/tomcat6"
CATALINA_BASE="/var/lib/tomcat6"
ANT_HOME="/usr/share/ant"
EOF
#
fi
#
grep -v PATH /etc/environment >> ~/.bashrc
echo "export JAVA_HOME CATALINA_HOME CATALINA_BASE ANT_HOME" >> ~/.bashrc
source ~/.bashrc
export CATALINA_HOME="/usr/share/tomcat6"
export CATALINA_BASE="/var/lib/tomcat6"
if [ -z "$CATALINA_BASE" ]
then
  echo "Failed to configure CATALINA_BASE in /etc/environment.  Exiting..."
  exit
fi
#
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config javaws
#
# install Oscar
if [ ! -d $HOME/git ]
then
  mkdir $HOME/git
fi
cd $HOME/git
#
# retrieve Oscar from github
if [ ! -d ./oscar ]
then
  git clone git://github.com/scoophealth/oscar.git
fi
if [ ! -d ./oscar ]
then
  exit
fi
cd ./oscar
git fetch origin
git checkout master
#
# build Oscar from source
export CATALINA_HOME
#
# This shouldn't be necessary but required in most recent deploys to avoid
# missing dependencies
mkdir -p ~/.m2/repository
rsync -av $HOME/git/oscar/local_repo/ $HOME/.m2/repository/
#
mvn -Dmaven.test.skip=true clean verify
sudo cp ./target/*.war $CATALINA_BASE/webapps/oscar14.war
#
# build oscar_documents from source
cd $HOME/git
if [ ! -d ./oscar_documents ]
then
  git clone git://oscarmcmaster.git.sourceforge.net/gitroot/oscarmcmaster/oscar_documents
else
  cd ./oscar_documents
  git pull
fi
cd $HOME/git
if [ ! -d ./oscar_documents ]
then
  exit
fi
cd ./oscar_documents
mvn -Dmaven.test.skip=true clean package
sudo cp ./target/*.war $CATALINA_BASE/webapps/OscarDocument.war
#
# create oscar database
cd $HOME/git/oscar/database/mysql
export PASSWORD=$oscar_passwd
./createdatabase_bc.sh root $PASSWORD oscar_14
#
cd $HOME
if [ ! -f $CATALINA_HOME/oscar14.properties ]
then
  if [ ! -f ./devops/Setup/oscar14-env-bc-subs.sed ]
  then
    echo "ERROR: sedscript is missing!"
    exit
  fi
  sed -f ./devops/Setup/oscar14-env-bc-subs.sed < $HOME/git/oscar/src/main/resources/oscar_mcmaster.properties > /tmp/oscar14.properties
  echo "ModuleNames=E2E" >> /tmp/oscar14.properties
  echo "E2E_URL = http://localhost:3001/records/create" >> /tmp/oscar14.properties
  echo "E2E_DIFF = off" >> /tmp/oscar14.properties
  echo "E2E_DIFF_DAYS = 14" >> /tmp/oscar14.properties
  echo "drugref_url=http://localhost:8080/drugref/DrugrefService" >> /tmp/oscar14.properties
  sed --in-place "s/db_password=xxxx/db_password=$oscar_passwd/" /tmp/oscar14.properties
  sudo cp /tmp/oscar14.properties $CATALINA_HOME/
fi
if [ ! -f /etc/default/tomcat6 ]
then
  echo "Tomcat6 is not installed!"
  exit
fi
sudo sed --in-place 's/JAVA_OPTS.*/JAVA_OPTS="-Djava.awt.headless=true -Xmx1024m -Xms1024m -XX:MaxPermSize=512m -server"/' /etc/default/tomcat6
#
# tweak MySQL server
cd $HOME/git/oscar/database/mysql
java -cp .:$HOME/git/oscar/local_repo/mysql/mysql-connector-java/3.0.11/mysql-connector-java-3.0.11.jar importCasemgmt $CATALINA_HOME/oscar14.properties
#
mysql -uroot -p$oscar_passwd -e 'insert into issue (code,description,role,update_date,sortOrderId) select icd9.icd9, icd9.description, "doctor", now(), '0' from icd9;' oscar_14
#
# import and update drugref
cd $HOME/git
wget http://drugref2.googlecode.com/files/drugref.war
sudo mv drugref.war $CATALINA_BASE/webapps/drugref.war
#
# Do not indent body of HERE document!
sudo bash -c "cat  >> $CATALINA_HOME/drugref.properties" <<'EOF'
db_user=root
db_password=xxxx
db_url=jdbc:mysql://127.0.0.1:3306/drugref
db_driver=com.mysql.jdbc.Driver
EOF
#
sudo sed --in-place "s/db_password=xxxx/db_password=$oscar_passwd/" $CATALINA_HOME/drugref.properties
#
# create a new database to hold the drugref.
mysql -uroot -p$oscar_passwd -e "CREATE DATABASE drugref;"
#
# To apply all the changes to the Tomcat server, we need to restart it
sudo /etc/init.d/tomcat6 restart
#
echo "loading drugref database..."
echo "This takes 15 minutes to 1 hour"
lynx http://localhost:8080/drugref/Update.jsp
