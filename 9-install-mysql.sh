#!/bin/bash

ID=$(id -u)
if [ $ID -ne 0 ]
then
echo "ERROR:please run this script with root access"
else
echo "you are root user"


yum install1 mysql -y
if [ $? -ne 0 ]
then
echo "ERROR:Installing mysql is failed"
exit1
else
echo "Installing mysql is success"
#yum install git -y
#if [ $? -ne 0 ]
#then
#echo "ERROR:Installing git is failed"
#exit1
#else
#echo "Installing git is success"
#fi
fi
fi