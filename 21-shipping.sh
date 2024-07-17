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
dnf install maven -y &>> $LOG_FILE
VALIDATE $? "installing maven"
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
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOG_FILE
VALIDATE $? "Downloading shipping script"
cd /app &>> $LOG_FILE
VALIDATE $? "Moveing to app directory"
unzip /tmp/shipping.zip &>> $LOG_FILE
VALIDATE $? "Unzipping shipping"
mvn clean package &>> $LOG_FILE
VALIDATE $? "Installing dependencies"
mv target/shipping-1.0.jar shipping.jar &>> $LOG_FILE
VALIDATE $? "Renameing jar files"
cp /home/centos/prasanna-daws-76s/ /etc/systemd/system/shipping.service &>> $LOG_FILE
VALIDATE $? "copying shipping service"
systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "deamon reload"
systemctl enable shipping &>> $LOG_FILE
VALIDATE $? "Enabling shipping"
systemctl start shipping &>> $LOG_FILE
VALIDATE $? "Starting shipping"
dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "Install mysql clint"
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOG_FILE
VALIDATE $? "Loading shipping data" 
systemctl restart shipping &>> $LOG_FILE
VALIDATE $? "Restart shipping"
