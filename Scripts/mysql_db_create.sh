#!/bin/bash
DBNAME="oscar15_bc"
INITFILE="$HOME/git/devops/Scripts/patient_insert.sql"
PASSWD="xxxxxxxxxx"
#
# Make sure mysqld is running
MYSQLPS=`ps h -C mysqld`
if [ -z "$MYSQLPS" ]; then
  sudo service mysql start
fi
#
# stop Oscar access to database
START_DATE=`date`
echo "Database recreation started at $START_DATE"
sudo /etc/init.d/tomcat7 stop
#
mysql -uroot -p$PASSWD -e "drop database $DBNAME;"
cd $HOME/git/oscar/database/mysql
./createdatabase_bc.sh root "$PASSWD" "$DBNAME"
#
echo "Starting Oscar to initialize program and provider_provider tables"
sudo /etc/init.d/tomcat7 start
echo "Sleeping for 60 seconds while Oscar starts up"
sleep 60
mysql -uroot -p$PASSWD $DBNAME < $INITFILE
#
END_DATE=`date`
echo "Database recreation ended at $END_DATE"
