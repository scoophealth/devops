devops
======

Temporary git repo for scripts in development for server configuration
and deployment.

Scripts used in this order:
  1. setup-base.sh
  2. setup-scoophealth.sh
  3. setup-tunnels.sh
  4. setup-oscar12.sh
  5. setup-gateway-monit.sh
  6. setup-hub-monit.sh

When the mongodb database is kept on an encrypted filesystem, additional
steps are necessary.  Some notes regarding this are kept in
upstart-monit-notes.txt.

Scripts to rebuild the Oscar EMR from source and to dump and restore
the Oscar database are in rebuild-oscar12.sh, mysql_dump.sh and
mysql_restore.sh respectively.
