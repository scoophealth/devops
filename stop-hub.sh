#!/bin/sh
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

