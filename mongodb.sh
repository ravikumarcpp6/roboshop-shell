#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "Script Started Executing at:$TIMESTAMP" &>> $LOGFILE

ID=$(id -u)
if [ $ID -ne 0 ]
    then 
        echo -e "$R ERROR...please run with root user $N"
        exit 1
    else
        echo -e "$G You are root user $N"  
fi          

VALIDATE(){
    if [ $1 -ne 0 ]
       then 
           echo -e "$2...$R FAILED $N"
       else
           echo -e "$2...$G SUCCESS $N"    
    fi      
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongoDB repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Remote Access to MongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"