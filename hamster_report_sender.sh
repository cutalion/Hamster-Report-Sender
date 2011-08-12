#!/bin/sh

if [ ! $1 ]; then
  echo "Please, specify date for the report: YYYY-MM-DD" > /dev/stderr
  exit
fi

if [ -f ./recipients.conf ]; then
  . ./recipients.conf
else
  echo "Create a recipients.conf file, please. See recipients.conf.template for example" > /dev/stderr
  exit
fi

DATE=$1
HAMSTER_DATE="$DATE 00:00:00"


# hamster-cli list "$HAMSTER_DATE" | sed -e '1,2d' | sed -re "s/[^(]+\\((.*)\\)/\\1/" | sort -t"@" -k2 > $list_file
hamster-cli list "$HAMSTER_DATE" | \
  sed -e '1,2d' | \
  sed -re "s/[^(]+\((.*)\)/\1/" | \
  awk -f report.awk #| mail -s "Report $DATE" $RECIPIENTS
