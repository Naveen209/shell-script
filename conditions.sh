#!/bin/bash
Userid=$(id -u)
script_name=$0
Date=$(date +%F:%H:%M:%S)
logfile=cat >>/tmp/$0-$Date.log

VALIDATE () {
if [ $1 -ne 0 ]
then
    echo "installation of $1 failure"
    exit 1
else
    echo "installation od $1 success"
fi
}
if [ $Userid -eq 0 ]
then
    echo "Running as root user starting installation"
else
    echo "Please run the script as root user"
fi 
yum install mysql -y &>>logfile
VALIDATE $?

