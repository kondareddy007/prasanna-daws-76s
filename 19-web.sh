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
dnf install nginx -y &>> $LOG_FILE
VALIDATE $? "Installing nginx"
systemctl enable nginx &>> $LOG_FILE
VALIDATE $? "Enabling nginx"
systemctl start nginx &>> $LOG_FILE
VALIDATE $? "Starting nginx"
rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
VALIDATE $? :Remove default web site"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip   
VALIDATE $? "Downloded web application"
cd /usr/share/nginx/html 
VALIDATE $? "moving nginx html directory"
unzip -o /tmp/web.zip 
VALIDATE $? "Unzipping web"
cp /home/centos/prasanna-daws-76s/roboshop-conf/ etc/nginx/default.d/roboshop.conf &>> $LOG_FILE
VALIDATE $? "Copied roboshop reverse proxy config"
systemctl restart nginx 
VALIDATE $? "Restart nginx"