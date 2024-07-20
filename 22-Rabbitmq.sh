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
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOG_FILE
VALIDATE $? "Downloding erlang script"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOG_FILE
VALIDATE $? "Downloding rabbitmq script"
dnf install rabbitmq-server -y &>> $LOG_FILE
VALIDATE $? "Installing rabbitmq server" 
systemctl enable rabbitmq-server &>> $LOG_FILE
VALIDATE $? "Enabling rabbitmq server"
systemctl start rabbitmq-server &>> $LOG_FILE
VALIDATE $? "Start rabbitmq server"
rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
VALIDATE $? "Creating user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
VALIDATE $? "Setting permissions"