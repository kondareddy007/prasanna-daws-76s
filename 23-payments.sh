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
dnf install python36 gcc python3-devel -y

id roboshop
if [ $? -ne 0 ]
then
useradd roboshop
VALIDATE $? "Roboshop user creation"
else
echo -e "roboshop user already exist $Y SKIPPINH $N"
fi
mkdir /app &>> $LOG_FILE
VALIDATE $? "Creating app directory"
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOG_FILE
VALIDATE $? "Dowloading payment"
cd /app &>> $LOG_FILE
VALIDATE $? "Moveing to app directory"
unzip /tmp/payment.zip &>> $LOG_FILE
VALIDATE $? "Unzipping payments"
pip3.6 install -r requirements.txt &>> $LOG_FILE
VALIDATE $? "Installing depenencies"
cp payments.service /etc/systemd/system/payment.service &>> $LOG_FILE
VALIDATE $? "copying payment service"
systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "Deamon reload"
systemctl enable payment &>> $LOG_FILE
VALIDATE $? "Enabling payment'
systemctl start payment   &>> $LOG_FILE
VALIDATE $? "Start payment"