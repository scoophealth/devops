This page outlines the installation procedure to be done on the SCOOP Endpoint hardware.

## Assumptions

Server hardware: Lenovo M92p i7-3770, 8GB RAM, 1TB HD, Win 7 Pro

## Procedure

Hold down F12 key to select boot device/setup.

Use GPartEd to resize Win 7 partition to 100GB. It should leave about 800GB free contiguous space after Win 7 partition.

**Install Ubuntu 12.04.3 AMD64 LTS Server into unused disk space**

* Name the computer scoophealth-0n where n is incremented for each new server
* Use "scoopadmin" for username
* Let Ubuntu automatically partition free disk space (but not entire disk)
* It should create 8GB swap partition and use the remainder for a single ext4 partition
* Initially use DHCP for network configuration
* Do not select automatic updates
* Include OpenSSH server during initial installation
* Reboot into Ubuntu and update with `sudo apt-get update` and then `sudo apt-get upgrade`
* Determine the IP address assigned to the server using `ifconfig eth0`.
* Access the server from the server using `ssh scoopadmin@theipaddress`.
* Access the server from somewhere else on the same ethernet segment via `ssh scoopadmin@theipaddress`
* Add a password to the root account.  Use `sudo su - root` to become root and set the root password with the `passwd` command.  This provides a second account with which the server can be accessed in the event that the scoopadmin account is inaccessible.

You can now disconnect keyboard, mouse and monitor since server is accessible via the network using ssh


**Add some basic packages using `apt-get install`**

`sudo apt-get install git python-software-properties curl`

**Download Server Setup Scripts from scoophealth/devops**

`cd $HOME; git clone git://github.com/scoophealth/devops`

**Examine the script [https://github.com/scoophealth/devops/blob/master/Setup/setup-base.sh](https://github.com/scoophealth/devops/blob/master/Setup/setup-base.sh).** This script is intended to be ran on a fresh Ubuntu 12.04 install.  It does the following:

* Adds Java 6 following procedure described at [http://www.webupd8.org/2012/11/oracle-sun-java-6-installer-available.html](http://www.webupd8.org/2012/11/oracle-sun-java-6-installer-available.html)
* Adds mongodb according to [http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/)
* Adds ruby and rails according to [http://rvm.io/](http://rvm.io/)
* Installs libraries and packages needed by scoophealth software

**Execute devops/Setup/setup-base.sh**

Beware:  These scripts are very fragile since they make many assumptions about the deployment hardware and software.  If uncertain, use them merely as examples of what needs to be done.  At the time of this writing, the following command works:

`cd $HOME; ./devops/Setup/setup-base.sh 2>&1 | tee -a /tmp/setup-base.log`

It will be necessary to hit enter a couple of times (particularly if the script appears to have halted during apt-get), and to accept the Oracle Java 6 statement of usage.  You may also need to enter the scoopadmin password to sudo.  These actions are required at the beginning of the install.  The script takes several minutes to execute.  After the setup script completes, check the logs for any error reports.  Since the script modifies the shell startup scripts for the scoopadmin account, make sure that `ssh localhost` logs into the scoopadmin account without any warnings or error messages before exiting the current shell.  After that check, it would be a good idea to reboot the server to ensure that all configuration changes work as expected.

**Install the endpoint (query-gateway) and hub (query-composer) packages**

`cd $HOME; ./devops/Setup/setup-scoophealth.sh`

**Install monit and configure autossh tunnels from endpoint to hub**

Prior to creating the autossh tunnels, the hub must be provided with the endpoint public key.  On the endpoint server being set up, create this key as follows:

*  `sudo su - root`
*  `ssh-keygen -t rsa # enter carriage returns to all queries`
*  `scp -p .ssh/id_rsa.pub scoopadmin@scoophub.cs.uvic.ca:/tmp/endpoint_id_rsa.pub`
*  `ssh scoopadmin@scoophub.cs.uvic.ca`
*  `sudo su - autossh`
*  Carefully check /tmp/endpoint_id_rsa.pub to ensure it is the right key.  If it is concatenate it to /home/autossh/.ssh/authorized_keys using `cat /tmp/endpoint_id_rsa.pub >> /home/autossh/.ssh/authorized_keys`.  Be very careful not to truncate the authorized_keys file leaving the endpoints unable to access the hub.  You might want to create a backup before modifying authorized_keys.
*  From the endpoint server verify that root can log into the autossh account on the hub without a password using:
`root@scoophealth-xx:~# ssh autossh@scoophub.cs.uvic.ca`
*  Log off scoophub
*  Log out of root account, back to scoopadmin account

Then proceed with:

`cd $HOME; ./devops/Setup/setup-tunnels.sh`

Executed without command-line arguments, setup-tunnels.sh will provide usage information.  Before executing the script, please examine it for errors.  Make sure that the gatewayID is a unique 2 digit integer within the Scoophealth network.  Use the server hostname suffix.  For instance, if the hostname is scoophealth-04, then use '04' as the gatewayID.  If the script succeeds, one should be able to log into the hub and locate the port assigned by the script.  (The script `$HOME/bin/checkports` will help here.)  For instance, host scoophealth-04 would use port 30304 on the hub and can be accessed from the hub through the reverse ssh tunnel using `ssh -p 30304 localhost`.  After connecting to the endpoint, make sure the command-line prompt is from the expected endpoint server!

**Setup OSCAR 12 with E2E support**

The devops/Setup/setup-oscar12 script must be provided with the password for the Oscar MySQL database.  It runs unattended except for a prompt during the initial MySQL installation which asks for the root MySQL account password which should match the password passed to the script.

At this point, the script hasn't been extensively tested so use with caution.  It assumes a specific installation environment.  Over time it will be improved to prevent emergent failure modes.

`cd $HOME; ./devops/Setup/setup-oscar12.sh`

The loading of the drugref database done at the end of the script can take 15-60 minutes. If loading of the database fails, from the command-line execute `lynx http://localhost:8080/drugref/Update.jsp` to try again.

**Place the endpoint software under monit control**

The devops/Setup/setup-gateway-monit.sh script creates endpoint software start and stop scripts kept in $HOME/bin of the scoopadmin account.  These scripts are used by monit to start and stop query-gateway.  Execute the script with

`cd $HOME; ./devops/Setup/setup-gateway-monit.sh`


