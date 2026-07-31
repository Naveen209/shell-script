#!/bin/bash
Userid=$(id -u)
script_name=$0
R="\e[31m"
G="\e[32m"
N="\e[0m"
Date=$(date +%F:%H:%M:%S)
logfile=/tmp/$script_name-$Date.log

VALIDATE () {
if [ $1 -ne 0 ]
then
    echo -e "installation of $2 $R failure $N"
    exit 1
else
    echo -e "installation of $2 $G success $N"
fi
}
if [ $Userid -eq 0 ]
then
    echo -e "$G Running as root user starting installation $N"
else
    echo -e "$R Please run the script as root user $N"
fi 
yum install mysqlll -y &>>logfile
VALIDATE $? "mysql"
yum install postfix -y &>>logfile
VALIDATE $? "postfix"

