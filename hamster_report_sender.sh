#!/bin/sh
. ./utils.sh

if [ ! $1 ]; then
  echo "Please, specify date for the report: YYYY-MM-DD"
  exit 1
fi

include ./config/recipients.conf

DATE=$1
HAMSTER_DATE="$DATE 00:00:00"


hamster-cli list "$HAMSTER_DATE" | \
  sed -e '1,2d' | \
  sed -re "s/[^(]+\((.*)\)/\1/" | \
  awk -f formatters/email.awk #| mail -s "Report $DATE" $RECIPIENTS
