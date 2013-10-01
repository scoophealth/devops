#!/bin/bash
if [ -z "$1" ]
then
  echo "Usage: setup-oscar.sh oscar_password"
  exit
fi
oscar_passwd=$1
echo "Create Oscar database with password $oscar_passwd"
#

cd $HOME
# install MySQL
if [ ! -d /var/lib/mysql ]
then
  sudo apt-get --yes install mysql-server libmysql-java
fi
# install Tomcat and Maven
if [ ! -d /var/lib/tomcat6 ]
then
  sudo apt-get --yes install tomcat6 maven git-core
  #
  # set up Tomcat's deployment environment
  # Do not indent body of HERE document!
  sudo bash -c "cat  >> /etc/environment" <<'EOF'
JAVA_HOME="/usr/lib/jvm/java-6-oracle"
CATALINA_HOME="/usr/share/tomcat6"
CATALINA_BASE="/var/lib/tomcat6"
ANT_HOME="/usr/share/ant"
EOF
#
fi
#
grep -v PATH /etc/environment >> ~/.bashrc
source ~/.bashrc
if [ -z "$CATALINA_BASE" ]
then
  echo "Failed to configure CATALINA_HOME in /etc/environment.  Exiting..."
  exit
fi
#
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config javaws
#
# install Oscar
if [ ! -d $HOME/emr ]
then
  mkdir $HOME/emr
fi
cd $HOME/emr
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
git checkout scoop-deploy
git pull
#
# build Oscar from source
export CATALINA_HOME
mvn -Dmaven.test.skip=true verify
sudo cp ./target/*.war $CATALINA_BASE/webapps/oscar12.war
#
# build oscar_documents from source
cd $HOME/emr
if [ ! -d ./oscar_documents ]
then
  git clone git://oscarmcmaster.git.sourceforge.net/gitroot/oscarmcmaster/oscar_documents
else
  cd ./oscar_documents
  git pull
fi
cd $HOME/emr
if [ ! -d ./oscar_documents ]
then
  exit
fi
cd ./oscar_documents
mvn -Dmaven.test.skip=true clean package
sudo cp ./target/*.war $CATALINA_BASE/webapps/OscarDocument.war
#
# create oscar database
cd $HOME/emr/oscar/database/mysql
export PASSWORD=$oscar_passwd
./createdatabase_bc.sh root $PASSWORD oscar_12_1
#
cd $HOME
if [ ! -f $CATALINA_HOME/oscar12.properties ]
then
  if [ ! -f ./oscar-env-bc-subs.txt ]
  then
    echo "ERROR: sedscript is missing!"
    exit
  fi
  sed -f ./oscar-env-bc-subs.txt < $HOME/emr/oscar/src/main/resources/oscar_mcmaster.properties > /tmp/oscar12.properties
  echo "ModuleNames=E2E" >> /tmp/oscar12.properties
  echo "E2E_URL = http://localhost:3001/records/create" >> /tmp/oscar12.properties
  echo "drugref_url=http://localhost:8080/drugref/DrugrefService" >> /tmp/oscar12.properties
  sed --in-place "s/db_password=xxxx/db_password=$oscar_passwd/" /tmp/oscar12.properties
  sudo cp /tmp/oscar12.properties $CATALINA_HOME/
fi
if [ ! -f /etc/default/tomcat6 ]
then
  echo "Tomcat6 is not installed!"
  exit
fi
sudo sed --in-place 's/JAVA_OPTS.*/JAVA_OPTS="-Djava.awt.headless=true -Xmx1024m -Xms1024m -XX:MaxPermSize=512m -server"/' /etc/default/tomcat6
#
# tweak MySQL server
cd $HOME/emr/oscar/database/mysql
java -cp .:$HOME/emr/oscar/local_repo/mysql/mysql-connector-java/3.0.11/mysql-connector-java-3.0.11.jar importCasemgmt $CATALINA_HOME/oscar12.properties
#
mysql -uroot -p$oscar_passwd -e 'insert into issue (code,description,role,update_date,sortOrderId) select icd9.icd9, icd9.description, "doctor", now(), '0' from icd9;' oscar_12_1
#
# import and update drugref
cd $HOME/emr
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
