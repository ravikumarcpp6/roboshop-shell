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