#!/bin/bash
FILE=/etc/passwd
username=prasanna
user_id=550
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
if [ ! -f $FILE ] #! denotes oppsite
then
echo -e "$R source directory:$FILE does not exist $N"
fi
while IFS=":" read -r username passwd user_id group_id user_fullname home_dir shell_path
do
echo "username:$username"
echo "user Id:$user_id"
echo "user fullname:"
done