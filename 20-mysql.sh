#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIME_STAMP=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$TIME_STAMP.log"
echo "Script started execting at $TIME_STAMP" &> $LOG_FILE
VALIDATE(){
if [ $1 -ne 0 ]
then
    echo -e "$2 ... $R Failed $N"
    exit 1
else
   echo -e "$2 .. $G Success $N"
fi
}
if [ $ID -ne 0 ]
then
echo -e "$R ERROR::Please run this script with root access $N"
exit 1
else
echo -e "$G You are root user $N"
fi
dnf module disable mysql -y
VALIDATE $? "Disable current mysql version"
cp mysql.repo /etc/yum.repos.d/mysql.repo
VALIDATE $? "Copied my sql repo"
dnf install mysql-community-server -y
VALIDATE $? "Installing mysql server"
systemctl enable mysqld
VALIDATE $? "Enabling mysql server"
systemctl start mysqld
VALIDATE $? "Start mysql"
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setting mysql root password"
mysql -uroot -pRoboShop@1