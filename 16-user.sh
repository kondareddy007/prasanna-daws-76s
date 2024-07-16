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
dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE $? "Desabling current nodejs" 
dnf module enable nodejs:18 -y &>> $LOG_FILE
VALIDATE $? "Enabling nodejs:18"
dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "Installing nodejs"
id roboshop
if [ $? -ne 0 ]
then
useradd roboshop &>> $LOG_FILE
VALIDATE $? "Roboshop user creation"
else
echo -e "Roboshop user is alredy exit $Y SKIPPING $N"
fi
VALIDATE $? "Creating roboshop user"
mkdir  -p /app &>> $LOG_FILE
VALIDATE $? "Creating app directory"
curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "Dowloading user application"
cd /app &>> $LOG_FILE
unzip /tmp/user.zip &>> $LOG_FILE
VALIDATE $? "Unzipping user"
npm install  &>> $LOG_FILE
VALIDATE $? "Installing dependencies"
cp /home/centos/prasanna-daws-76s/user.service /etc/systemd/system/catalogue.service &>> $LOG_FILE
VALIDATE $? "copying user sevice file"
systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "user deomon reload"
systemctl enable user &>> $LOG_FILE
VALIDATE $? "Enabling user"
systemctl start user &>> $LOG_FILE
VALIDATE $? "Starting user"
cp /home/centos/prasanna-daws-76s/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
VALIDATE $? "copying mongo repo"
dnf install mongodb-org-shell -y &>> $LOG_FILE
VALIDATE $? "Installing mongodb client"
mongo --host 172.31.91.200 </app/schema/catalogue.js
VALIDATE $? "loading user data into mongodb"