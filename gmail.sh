#!/bin/bash
LOGSDIR=/tmp
DATE=$(date +%F)
R="\e[31m"
G="\e[32m"
N="\e[0m"
SCRIPT_NAME=$(basename "$0" .sh)
LOGFILE="$LOGSDIR/$SCRIPT_NAME-$DATE.log"
USERID=$(id -u)
SASL_FILE="/etc/postfix/sasl_passwd"
SMTP_SERVER="[smtp.gmail.com]:587"
SMTP_USER="naveenkumarseelam209@gmail.com"

VALIDATE() {
    if [ $? -ne 0 ]
    then
        echo -e " $2 $R FAILURE $N "
    else
        echo -e " $2 $G SUCCESS $N "
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "$R This script execution requires root access, rerunning as root user $N"
    exec sudo bash "$0" "$@" &>> "$LOGFILE"
fi
yum update -y --exclude=kernel* &>> "$LOGFILE"
VALIDATE $? "Update kernel"
yum install -y postfix cyrus-sasl cyrus-sasl-plain &>> "$LOGFILE"
VALIDATE $? "Installing postfix"
systemctl start postfix &>> "$LOGFILE"
VALIDATE $? "Starting postfix"
systemctl enable postfix &>> "$LOGFILE"
VALIDATE $? "enable postfix"
systemctl status postfix &>> "$LOGFILE"
VALIDATE $? "enable postfix"

cp postfix.repo /etc/postfix/main.cf &>> "$LOGFILE"
VALIDATE $? "Copying repos"
read -s -p "Enter Gmail App Password: " SMTP_PASS
echo
VALIDATE $? "Password authenticated"
echo
echo "${SMTP_SERVER} ${SMTP_USER}:${SMTP_PASS}" > "$SASL_FILE"
chmod 600 "$SASL_FILE"
postmap "$SASL_FILE"
systemctl restart postfix
systemctl status postfix &>> "$LOGFILE"
echo "This is a test mail & Date $(date)" | mail -s "CentOS 9 Test" "$SMTP_USER"
VALIDATE $? "Sending test mail"
