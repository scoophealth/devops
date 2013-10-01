#!/bin/bash
#
##
## Create bin/start-endpoint.sh
##
if [ ! -d $HOME/bin ]
then
  mkdir $HOME/bin
fi
#
cat > $HOME/bin/start-endpoint.sh << 'EOF1'
#!/bin/bash
export HOME=/home/scoopadmin
source $HOME/.bash_profile
source $HOME/.bashrc
#
#echo "Starting relay service on port 3000"
#$HOME/endpoint/query-gateway/util/relay-service.rb >> $HOME/logs/rs.log 2>&1 &
#
echo "Starting Query Gateway on port 3001"
cd $HOME/endpoint/query-gateway
if [ -f $HOME/endpoint/query-gateway/tmp/pids/delayed_job.pid ];
then
  bundle exec $HOME/endpoint/query-gateway/script/delayed_job stop
  rm $HOME/endpoint/query-gateway/tmp/pids/delayed_job.pid
fi
#
bundle exec $HOME/endpoint/query-gateway/script/delayed_job start
#
# Start gateway
# If gateway is already running (or has a stale server.pid), try to stop it.
if [ -f $HOME/endpoint/query-gateway/tmp/pids/server.pid ];
then
  kill `cat $HOME/endpoint/query-gateway/tmp/pids/server.pid`
  if [ -f $HOME/endpoint/query-gateway/tmp/pids/server.pid ];
  then
    kill -9 `cat $HOME/endpoint/query-gateway/tmp/pids/server.pid`
  fi
  rm $HOME/endpoint/query-gateway/tmp/pids/server.pid
fi
bundle exec rails server -p 3001 -d
#/bin/ps -ef | grep "rails server -p 3001" | grep -v grep | awk '{print $2}' > tmp/pids/server.pid
#
#cd $HOME/logs
#tail -f rs.log
EOF1
#
##
## Create bin/stop-endpoint.sh
##
cat > $HOME/bin/stop-endpoint.sh << 'EOF2'
#!/bin/bash
export HOME=/home/scoopadmin
source $HOME/.bash_profile
source $HOME/.bashrc
cd $HOME/endpoint/query-gateway
if [ -f $HOME/endpoint/query-gateway/tmp/pids/delayed_job.pid ];
then
  bundle exec $HOME/endpoint/query-gateway/script/delayed_job stop
  # pid file should be gone but recheck
  if [ -f $HOME/endpoint/query-gateway/tmp/pids/delayed_job.pid ];
  then
    rm $HOME/endpoint/query-gateway/tmp/pids/delayed_job.pid
  fi
fi
#
# If gateway is running, stop it.
if [ -f $HOME/endpoint/query-gateway/tmp/pids/server.pid ];
then
  kill `cat $HOME/endpoint/query-gateway/tmp/pids/server.pid`
  if [ -f $HOME/endpoint/query-gateway/tmp/pids/server.pid ];
  then
    kill -9 `cat $HOME/endpoint/query-gateway/tmp/pids/server.pid`
  fi
  rm $HOME/endpoint/query-gateway/tmp/pids/server.pid
fi
EOF2
#
chmod a+x $HOME/bin/*
#
## Configure monit to enable command-line monit tools
sudo bash -c "cat >> /etc/monit/monitrc" << 'EOF0'
#
# needed so that monit command-line tools will work
set httpd port 2812 and
use address localhost
allow localhost
EOF0
##
#
##
## Configure monit to control the query-gateway
##
#!/bin/bash
#
#Setup monit to start query-gateway
sudo bash -c "cat > /etc/monit/conf.d/query-gateway" <<'EOF1'
# Monitor gateway
check process query-gateway with pidfile /home/scoopadmin/endpoint/query-gateway/tmp/pids/server.pid
    start program = "/home/scoopadmin/bin/start-endpoint.sh" as uid scoopadmin and with gid scoopadmin
    stop program = "/home/scoopadmin/bin/stop-endpoint.sh" as uid scoopadmin and with gid scoopadmin
    if 100 restarts within 100 cycles then timeout
EOF1
#
sudo /etc/init.d/monit reload
