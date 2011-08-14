#!/bin/bash
. ./utils.sh

include ./config/clockwork.conf

login
if [ $? == 0 ]; then
  echo "Logged in."
else
  echo "Can not login into clockwork :("
  exit 1
fi

echo "Posting timelogs:"
visit "$CLOCKWORK_URL/timelogs"
post_timelog "2011-08-14" "2.5" "testing" "Project 1" && echo -n .

echo ''
echo "Done."
