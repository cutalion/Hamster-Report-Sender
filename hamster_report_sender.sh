#!/bin/sh
. ./utils.sh

if [ ! $1 ]; then
  echo "Please, specify date for the report: YYYY-MM-DD"
  exit 1
fi

include ./config/recipients.conf

date=$1
formatter=${2:-email}
hamster_date="$date 00:00:00"



hamster-cli list "$hamster_date" | \
  sed -e '1,2d' | \
  sed -re "s/[^(]+\((.*)\)/\1/" | \
  awk -f formatters/$formatter.awk #| mail -s "Report $DATE" $RECIPIENTS
