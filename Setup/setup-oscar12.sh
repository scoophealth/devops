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
# Make sure tomcat6 finds right JAVA_HOME
if ! grep --quiet "java-6-oracle" /etc/default/tomcat6
then
  sudo bash -c 'echo JAVA_HOME=/usr/lib/jvm/java-6-oracle >> /etc/default/tomcat6'
fi
sudo /etc/init.d/tomcat6 restart
#
grep -v PATH /etc/environment >> ~/.bashrc
echo "export JAVA_HOME CATALINA_HOME CATALINA_BASE ANT_HOME" >> ~/.bashrc
source ~/.bashrc
#
for line in $( cat /etc/environment|grep -v PATH ) ; do export $line ; done
if [ -z "$CATALINA_BASE" -a -d "$CATALINA_BASE" ]
then
  echo "Failed to configure CATALINA_BASE in /etc/environment.  Exiting..."
  exit
fi
if [ -z "$CATALINA_HOME" -a -d "$CATALINA_HOME" ]
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
  git clone -b scoop-deploy git://github.com/scoophealth/oscar.git
fi
if [ ! -d ./oscar ]
then
  exit
fi
cd ./oscar
git fetch origin
git checkout scoop-deploy
git reset --hard origin/scoop-deploy
# Tomcat versions 6.0.38 and 6.0.39 renamed the validateXml attribute
# to validateTld causing build errors like this:
# [ERROR] BUILD ERROR
# [INFO]
# ------------------------------------------------------------------------
# [INFO] An Ant BuildException has occured: The following error occurred
# while executing this line:
# jspc.xml:49: jasper doesn't support the "validateXml" attribute
# around Ant part ...<ant antfile="jspc.xml" target="jspc"/>... @ 5:42 in
# target/antrun/build-main.xml
sed -i 's/validateXml="false"//' jspc.xml
# Note Ubuntu 14.04 deploys Tomcat 6.0.39 by default as of Oct 2014
#
# build Oscar from source
# These environment variables somehow are not set properly
# at this point so setting them again explicitly.
export JAVA_HOME="/usr/lib/jvm/java-6-oracle"
export CATALINA_HOME="/usr/share/tomcat6"
export CATALINA_BASE="/var/lib/tomcat6"
#
# Patch to catalina-tasks.xml
# (See https://issues.apache.org/bugzilla/show_bug.cgi?id=56560)
# Without this patch, get errors like:
# [ERROR] BUILD ERROR
# [INFO] -----------------------------------------------------------------------
# [INFO] An Ant BuildException has occured: The following error occurred while executing this line:
# jspc.xml:49: java.lang.NoClassDefFoundError: org/apache/tomcat/util/descriptor/LocalResolver
# around Ant part ...<ant antfile="jspc.xml" target="jspc"/>... @ 6:42 in target/antrun/build-main.xml
if ! grep --quiet "tomcat-coyote.jar" $CATALINA_HOME/bin/catalina-tasks.xml
then
  sudo sed -i '/<fileset file="${catalina.home}\/lib\/servlet-api.jar"\/>/a<fileset file="${catalina.home}\/lib\/tomcat-coyote.jar"\/>' $CATALINA_HOME/bin/catalina-tasks.xml
fi
#
# This shouldn't be necessary but required in most recent deploys to avoid
# missing dependencies
mkdir -p ~/.m2/repository
rsync -av $HOME/emr/oscar/local_repo/ $HOME/.m2/repository/
#
mvn -Dmaven.test.skip=true clean verify
# stop tomcat before deploying new war since database isn't configured yet
sudo /etc/init.d/tomcat6 stop
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
# first drop any old version
mysql -uroot -p$oscar_paswd -e "DROP DATABASE IF EXISTS oscar_12_1;"
cd $HOME/emr/oscar/database/mysql
export PASSWORD=$oscar_passwd
./createdatabase_bc.sh root $PASSWORD oscar_12_1
#
cd $HOME
if [ ! -f $CATALINA_HOME/oscar12.properties ]
then
  if [ ! -f ./devops/Setup/oscar-env-bc-subs.sed ]
  then
    echo "ERROR: sedscript is missing!"
    exit
  fi
  sed -f ./devops/Setup/oscar-env-bc-subs.sed < $HOME/emr/oscar/src/main/resources/oscar_mcmaster.properties > /tmp/oscar12.properties
  echo "ModuleNames=E2E" >> /tmp/oscar12.properties
  echo "E2E_URL = http://localhost:3001/records/create" >> /tmp/oscar12.properties
  echo "E2E_DIFF = off" >> /tmp/oscar12.properties
  echo "E2E_DIFF_DAYS = 14" >> /tmp/oscar12.properties
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
mysql -uroot -p$oscar_paswd -e "DROP DATABASE IF EXISTS drugref;"
mysql -uroot -p$oscar_passwd -e "CREATE DATABASE drugref;"
#
# To apply all the changes to the Tomcat server, we need to restart it
sudo /etc/init.d/tomcat6 restart
#
echo "loading drugref database..."
echo "This takes 15 minutes to 1 hour"
lynx http://localhost:8080/drugref/Update.jsp
