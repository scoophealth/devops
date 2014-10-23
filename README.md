devops
======

Temporary git repo for scripts in development for server configuration
and deployment.

Scripts used in this order:
  1. setup-base.sh
  2. setup-scoophealth.sh
  3. setup-tunnels.sh (for endpoint servers)
  4. setup-oscar12.sh (for endpoint servers at Oscar sites)
  5. setup-gateway-monit.sh (for endpoint servers, pass script username of account running query-gateway, defaults to scoopadmin)
  6. setup-hub-monit.sh (for hub server)
  7. setup-security.sh

Scripts to rebuild the Oscar EMR from source and to dump and restore
the Oscar database are in rebuild-oscar12.sh, mysql_dump.sh and
mysql_restore.sh respectively.
