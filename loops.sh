#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
SCRIPT_NAME=$0
DATE=(date +%F:%H:%M:%S)
LOGSDIR=/home/centos/shellscript-logs
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log
VALIDATE() {
    if [$? -ne 0 ]
    then
        echo -e "installation of $2 $R FAILURE $N"
    else
        echo -e "installation of $2 $G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "$R Please run the script as root user $N"
    exit 1
fi

for i in $@
do
  yum list installed $i
  if [ $? -ne 0 ]
  then
      echo -e "$i not installed lets install it"
      yum install $i -y &>>LOGFILE
      VALIDATE $? "$i"
  else
      echo -e "$Y $i is already installed $N"
  fi
done