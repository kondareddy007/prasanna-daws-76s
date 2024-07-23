#!/bin/bash
DISK_USAGE=$(df -hT|grep -vE "tmp/file")
DISH_THRESHOLD=1
Message=""
while IFS read line
do
usage=$( echo $ | awk '{print $6F}'| cut -d % f1 )
partition=$(echo $line|awk '{print $1F}')
if [ $Usage -gt $DISK_THRESHOLD ]
then
Message +="High disk usage on $partition:$Usage<br>"
fi
done <<<$DISK_USAGE
echo -e "Message:$Message"
#echo "$Message"|mail -s "High disk usage"info@joindevops.com
#sh mail.sh"Devops Team high disk usage""$Message"info@joindenvops.com"ALERT high disk usage