#!/bin/bash
DATE=$(date +%F:%H:%M:%S)
LOGSDIR=/tmp
SCRIPT_NAME=$(basename "$0" .sh)
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)
R="\[31m"
G="\[32m"
N="\[0m"
Y="\[33m"
VALIDATE() {
    if [ $USERID -ne 0 ]
    then
         echo -e " $2 $R FAILURE $N "
    else
        echo -e " $2 $G SUCCESS $N "
    fi 
}
DISK_USAGE=$(df -hT | grep xfs)
while read in line
do
  usage=$(echo $line | awk '{sub("%","",$6); print $6}')
  partition=$(echo $line | awk '{print $1}')
  if [ $usage -gt 10]
  then
      message+="HIGH DISK USAGE ON: $partition: $usage \n"
  fi
done <<< $DISK_USAGE
echo -e "message: $message"