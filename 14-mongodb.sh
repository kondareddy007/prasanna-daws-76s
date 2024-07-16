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
if [ $ID -ne 0 ]``
then
echo -e "$R ERROR::Please run this script with root access $N"
exit 1
else
echo -e "$G You are root user $N"
fi
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
VALIDATE $? "copied mongo.repo"
dnf install mongodb-org -y 
systemctl enable mongod &>> $LOG_FILE
VALIDATE $? "Enable mongodb"
systemctl start mongod &>> $LOG_FILE
VALIDATE $? "Start mongodb"
sed -i 's/127.0.0.1 / 0.0.0.0 /g' /etc/mongod.conf &>> $LOG_FILE
VALIDATE $? "Remote access to mongodb"
systemctl restart mongod &>> $LOG_FILE
