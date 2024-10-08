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
VALIDATE $? "Desabling current nsodejs" 
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
curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "Dowloading cart application"
cd /app &>> $LOG_FILE
unzip -o /tmp/cart.zip &>> $LOG_FILE
VALIDATE $? "Unzipping cart"
npm install  &>> $LOG_FILE
VALIDATE $? "Installing dependencies"
cp /home/centos/prasanna-daws-76s/catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_FILE
VALIDATE $? "copying cart sevice file"
systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "cart deomon reload"
systemctl enable cart &>> $LOG_FILE
VALIDATE $? "Enabling cart"
systemctl start cart &>> $LOG_FILE
VALIDATE $? "Start cart"