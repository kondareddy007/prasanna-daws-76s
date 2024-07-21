#!/bin/bash
DISK_USAGE=$(df -hT|grep -vE "tmp/file")
DISH_THRESHOLD=1
Message=""
while IFS read line
do
Usage=$(echo $line|awk '{print $6F}'|cut -d%f1)
partition=$(echo $line|awk '{print $1F}')
if [ $Usage -gt $DISK_THRESHOLD ]
then
Message +="High disk usage on $partition:$Usage<br>"
fi
done <<<$DISK_USAGE
echo -e "Message:$Message