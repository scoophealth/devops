#!/bin/bash
#
set -e # exit on errors
#
if sudo test ! -d "/root/.ssh"
then
  echo "No /root/.ssh directory"
  echo "Please read Server-Configuration.md in this repo."
  exit
fi
if sudo test ! -f "/root/.ssh/id_rsa.pub"
then
  echo "A public rsa key is needed to connect to hub."
  echo "Please read Server-Configuration.md in this repo."
  exit
fi
# test where file can be copied to hub via ssh
echo "The public rsa key must be copied to the hub before we can continue."
echo "Checking that now..."
hostname=`hostname`
sudo scp /root/.ssh/id_rsa.pub autossh@pdchub.uvic.ca:/tmp/"$hostname"_id_rsa.pub
if [ ! $? -eq 0 ]
then
  echo "Please read Server-Configuration.md in this repo."
  exit
fi
if [ ! -x "/usr/bin/autossh" ]
then
  sudo apt-get --yes install autossh
fi
if [ ! -x "/usr/bin/monit" ]
then
  sudo apt-get --yes install monit
fi
if [ -z "$1" ]
then
  echo "Usage: setup-tunnels.sh gatewayID"
  echo " * Note: The gatewayID must be a unique integer (e.g. 05).  If less than 10 prefix with a 0."
  exit
fi
gatewayID=$1
#
echo
#if [ ! -d /home/autossh/.ssh ]
#then
#  echo "Creating unprivileged user account <autossh> for reverse ssh tunnelling"
#  echo "The root user public rsa key for each endpoint must be added to "
#  echo "/home/autossh/.ssh/authorized_keys on the hub."
#  sudo adduser --disabled-password autossh
#  sudo mkdir /home/autossh/.ssh
#  sudo touch /home/autossh/.ssh/authorized_keys
#  #sudo vi /home/autossh/.ssh/authorized_keys
#  sudo chmod -R go-rwx /home/autossh/.ssh
#  sudo chown -R autossh:autossh /home/autossh/.ssh
#fi
#
if [ ! -d /usr/local/reverse_ssh/bin ]
then
  sudo mkdir -p /usr/local/reverse_ssh/bin
fi
sudo bash -c "cat  > /usr/local/reverse_ssh/bin/start_admin_tunnel.sh" <<'EOF1'
#!/bin/bash
REMOTE_ACCESS_PORT=30308
LOCAL_PORT_TO_FORWARD=22
export AUTOSSH_PIDFILE=/usr/local/reverse_ssh/autossh_admin.pid
/usr/bin/autossh -M0 -p22 -N -R ${REMOTE_ACCESS_PORT}:localhost:${LOCAL_PORT_TO_FORWARD} autossh@pdchub.uvic.ca -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o Protocol=2 -o ExitOnForwardFailure=yes &
#
EOF1
#
sudo bash -c "sed -i -e s/REMOTE_ACCESS_PORT=30308/REMOTE_ACCESS_PORT=`expr 30300 + $gatewayID`/ /usr/local/reverse_ssh/bin/start_admin_tunnel.sh"

sudo bash -c "cat  > /usr/local/reverse_ssh/bin/start_endpoint_tunnel.sh" <<'EOF2'
#!/bin/bash
REMOTE_ACCESS_PORT=13001
LOCAL_PORT_TO_FORWARD=3001
export AUTOSSH_PIDFILE=/usr/local/reverse_ssh/autossh_endpoint.pid
/usr/bin/autossh -M0 -p22 -N -R ${REMOTE_ACCESS_PORT}:localhost:${LOCAL_PORT_TO_FORWARD} autossh@pdchub.uvic.ca -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o Protocol=2 -o ExitOnForwardFailure=yes &
#
EOF2
#
sudo bash -c "sed -i -e s/REMOTE_ACCESS_PORT=13001/REMOTE_ACCESS_PORT=`expr 10300 + $gatewayID`/ /usr/local/reverse_ssh/bin/start_endpoint_tunnel.sh"
#
sudo bash -c "cat  > /usr/local/reverse_ssh/bin/stop_admin_tunnel.sh" <<'EOF3'
#!/bin/sh
test -e /usr/local/reverse_ssh/autossh_admin.pid && kill `cat /usr/local/reverse_ssh/autossh_admin.pid`
EOF3
#
sudo bash -c "cat  > /usr/local/reverse_ssh/bin/stop_endpoint_tunnel.sh" <<'EOF4'
#!/bin/sh
test -e /usr/local/reverse_ssh/autossh_endpoint.pid && kill `cat /usr/local/reverse_ssh/autossh_endpoint.pid`
EOF4
#
sudo chown -R root:root /usr/local/reverse_ssh
sudo chmod 700 /usr/local/reverse_ssh/bin/*.sh
#
#Setup monit to restart autossh
sudo bash -c "cat > /etc/monit/conf.d/autossh_admin" <<'EOF5'
# Monitor autossh_admin
check process autossh_admin with pidfile /usr/local/reverse_ssh/autossh_admin.pid
    start program = "/usr/local/reverse_ssh/bin/start_admin_tunnel.sh"
    stop program = "/usr/local/reverse_ssh/bin/stop_admin_tunnel.sh"
    if 100 restarts within 100 cycles then timeout
EOF5
#
sudo bash -c "cat > /etc/monit/conf.d/autossh_endpoint" <<'EOF6'
# Monitor autossh_endpoint
check process autossh_endpoint with pidfile /usr/local/reverse_ssh/autossh_endpoint.pid
    start program = "/usr/local/reverse_ssh/bin/start_endpoint_tunnel.sh"
    stop program = "/usr/local/reverse_ssh/bin/stop_endpoint_tunnel.sh"
    if 100 restarts within 100 cycles then timeout
EOF6
#
#
if sudo bash -c 'grep --quiet "^set httpd port 2812" /etc/monit/monitrc'
then
  echo '/etc/monit/monitrc already setup for CLI access'
else
  # don't indent the here document
  sudo bash -c "cat >> /etc/monit/monitrc" << 'EOF7'
#
# needed so that monit command-line tools will work
set httpd port 2812 and
use address localhost
allow localhost
EOF7
fi
#
if sudo test -f "/var/spool/cron/crontabs/root"
then
  if sudo bash -c 'grep --quiet autossh_admin /var/spool/cron/crontabs/root'
  then
    echo 'root cron already set to restart auto_ssh'
  else
    echo 'adding monit start autossh_admin to root crontab'
    sudo crontab -u root -l /root/crontab.root
    # don't indent here document below
    sudo bash -c "cat >> /root/crontab.root" << 'EOF8'
# Run five minutes after hour, every day
# Provides automatic recovery if monit unmonitors autossh_admin
5 * * * *  /usr/bin/monit start autossh_admin >> /var/log/monit-cron.log 2>&1
EOF8
    sudo crontab -u root /root/crontab.root
  fi
else
  echo 'creating root crontab with monit start autossh_admin
  # don't indent here document below
  sudo bash -c "cat > /root/crontab.root" << 'EOF9'
# Run five minutes after hour, every day
# Provides automatic recovery if monit unmonitors autossh_admin
5 * * * *  /usr/bin/monit start autossh_admin >> /var/log/monit-cron.log 2>&1
EOF9
    sudo crontab -u root /root/crontab.root
fi
#
sudo /etc/init.d/monit restart
#
echo
echo "Access endpoint from account on hub as follows:"
echo "ssh -l $USER localhost -p 303[0n] where 0n is the gatewayID"
echo "Note that the password request is for the $USER account"
echo "on the endpoint which can be different from the password of"
echo "the $USER acount on the hub."
