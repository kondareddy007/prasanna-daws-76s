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
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOG_FILE
VALIDATE $? "Installing remi release"
dnf module enable redis:remi-6.2 -y &>> $LOG_FILE
VALIDATE $? "Enabling redis"
dnf install redis -y &>> $LOG_FILE
VALIDATE $? "Installing redis"
sed -i "s/127.0.0.1/0.0.0.o/g" /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"
systemctl enable redis &>> $LOG_FILE
VALIDATE $? "Enabling redis"
systemctl start redis &>> $LOG_FILE
VALIDATE $? "Start redis"