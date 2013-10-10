#!/bin/sh
if [ -z "$3" ]
then
  echo "Usage: $0 password dbname dump_file"
  exit
fi
PASSWD=$1
DBNAME=$2
DUMPFILE=$3
#
# stop Oscar access to database
sudo /etc/init.d/tomcat6 stop
#
mysql -uroot -p$PASSWD -e "drop database $DBNAME;"
mysql -uroot -p$PASSWD -e "create database $DBNAME;"
mysql -uroot -p$PASSWD $DBNAME < $DUMPFILE
#
# restart Oscar
sudo /etc/init.d/tomcat6 start
