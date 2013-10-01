#!/bin/sh
cd $HOME/hub/query-composer
if [ -f $HOME/hub/query-composer/tmp/pids/delayed_job.pid ];
then
  bundle exec $HOME/hub/query-composer/script/delayed_job stop
  rm $HOME/hub/query-composer/tmp/pids/delayed_job.pid
fi
bundle exec $HOME/hub/query-composer/script/delayed_job start

bundle exec script/delayed_job start
bundle exec rails server -p 3002 -d
