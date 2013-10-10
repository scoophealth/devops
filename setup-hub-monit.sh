#!/bin/bash
#
##
## Setup autossh account for reverse ssh from gateways
##
echo
if [ ! -d /home/autossh/.ssh ]
then
echo "Creating unprivileged user account <autossh> for reverse ssh tunnelling"
  echo "The root user public rsa key for each endpoint must be added to "
  echo "/home/autossh/.ssh/authorized_keys on the hub."
  sudo adduser --disabled-password autossh
  sudo mkdir /home/autossh/.ssh
  sudo touch /home/autossh/.ssh/authorized_keys
  #sudo vi /home/autossh/.ssh/authorized_keys
  sudo chmod -R go-rwx /home/autossh/.ssh
  sudo chown -R autossh:autossh /home/autossh/.ssh
fi
#
##
## Create bin/start-hub.sh
##
if [ ! -d $HOME/bin ]
then
  mkdir $HOME/bin
fi
#
cat > $HOME/bin/start-hub.sh << 'EOF1'
#!/bin/bash
export HOME=/home/scoopadmin
source $HOME/.bash_profile
source $HOME/.bashrc
#
#
echo "Starting Query Composer on port 3002"
cd $HOME/hub/query-composer
if [ -f $HOME/hub/query-composer/tmp/pids/delayed_job.pid ];
then
  bundle exec $HOME/hub/query-composer/script/delayed_job stop
  rm $HOME/hub/query-composer/tmp/pids/delayed_job.pid
fi
#
bundle exec $HOME/hub/query-composer/script/delayed_job start
#
# Start gateway
# If gateway is already running (or has a stale server.pid), try to stop it.
if [ -f $HOME/hub/query-composer/tmp/pids/server.pid ];
then
  kill `cat $HOME/hub/query-composer/tmp/pids/server.pid`
  if [ -f $HOME/hub/query-composer/tmp/pids/server.pid ];
  then
    kill -9 `cat $HOME/hub/query-composer/tmp/pids/server.pid`
  fi
  rm $HOME/hub/query-composer/tmp/pids/server.pid
fi
bundle exec rails server -p 3002 -d
#/bin/ps -ef | grep "rails server -p 3002" | grep -v grep | awk '{print $2}' > tmp/pids/server.pid
EOF1
#
##
## Create bin/stop-hub.sh
##
cat > $HOME/bin/stop-hub.sh << 'EOF2'
#!/bin/bash
export HOME=/home/scoopadmin
source $HOME/.bash_profile
source $HOME/.bashrc
cd $HOME/hub/query-composer
if [ -f $HOME/hub/query-composer/tmp/pids/delayed_job.pid ];
then
  bundle exec $HOME/hub/query-composer/script/delayed_job stop
  # pid file should be gone but recheck
  if [ -f $HOME/hub/query-composer/tmp/pids/delayed_job.pid ];
  then
    rm $HOME/hub/query-composer/tmp/pids/delayed_job.pid
  fi
fi
#
# If gateway is running, stop it.
if [ -f $HOME/hub/query-composer/tmp/pids/server.pid ];
then
  kill `cat $HOME/hub/query-composer/tmp/pids/server.pid`
  if [ -f $HOME/hub/query-composer/tmp/pids/server.pid ];
  then
    kill -9 `cat $HOME/hub/query-composer/tmp/pids/server.pid`
  fi
  rm $HOME/hub/query-composer/tmp/pids/server.pid
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
## Configure monit to control the query-composer
##
#!/bin/bash
#
#Setup monit to start query-composer
sudo bash -c "cat > /etc/monit/conf.d/query-composer" <<'EOF1'
# Monitor gateway
check process query-composer with pidfile /home/scoopadmin/hub/query-composer/tmp/pids/server.pid
    start program = "/home/scoopadmin/bin/start-hub.sh" as uid scoopadmin and with gid scoopadmin
    stop program = "/home/scoopadmin/bin/stop-hub.sh" as uid scoopadmin and with gid scoopadmin
    if 100 restarts within 100 cycles then timeout
EOF1
#
sudo /etc/init.d/monit reload
