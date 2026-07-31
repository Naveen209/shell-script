#!/bin/bash
Userid=$(id -u)
script_name=$0
Date=$(date)
logfile=/tmp/$0-Date.log
if [$Userid -eq 0]
then
    echo "Running as root user starting installation"
else
    echo "Please run the script as root user"
fi 
yum install mysql -y &>>logfile
if [$? -ne 0]
then
    echo "installation failure"
    exit 1
else
    echo "installation success"
fi