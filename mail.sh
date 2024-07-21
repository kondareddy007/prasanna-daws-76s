#!/bin/bash
TO_TEAM=$1
ALERT_TYPE=$2
BODY=$3
ESCAPE_BODY=ESCAPED_KEYWORD=$(printf "%s\n"KEYWORD"|sed -e's/[]\/s'.^[]/\\&|g')"
TO_ADDRESS=$4
SUBJECT=$5
FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/BODY/$BODY/g" $ESCAPE_BODY/g"template.html)
echo "$FINAL_BODY"|mail -s "$SUBJECT""$TO_ADDRESS"