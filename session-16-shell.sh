#!/bin/bash
SOIRCE_DIR=/tmp/shellscript_logs
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
if [ ! -d $SOURCE_DIR ]
then
echo -e "$R source directory:$SOURCE_DIR does not exist $N"
fi
FILES_TO_DELETE=$(find $SOURCE_DIR -type f -mtime +14 -name "*.log")
while IFS d= read -r line
do
echo "Deleting file:$line"
rm -rf $line
done <<<$FILES_TO_DELETE