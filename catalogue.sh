#!/bin/bash

ID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "The script started executing at:$TIMESTAMP" &>> $LOGFILE

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#MONGODB_HOST="mongodb.devopspractice.shop"

if [ $ID -ne 0 ]
    then
        echo -e "$R ERROR:: PLEASE RUN WITH ROOT USER $N"
        exit 1
    else
        echo -e "$G YOU ARE A ROOT USER $N"    
fi    

VALIDATE(){
    if [ $1 -ne 0 ]

       then
            echo -e "$2...$R FAILED $N"
            else 
                echo -e "$2...$G SUCCESS $N"
    fi            
}

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs 18 version"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs18"

id roboshop
if [ $? -ne 0 ]
    then 
        useradd roboshop 
        VALIDATE $? "ROBOSHOP USER Creation"
    else
         echo -e "$R ROBOSHOP USER ALREADY EXIST....$Y SKIPPING... $N"    
fi         

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app Directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading Catalogue application" 

cd /app  &>> $LOGFILE

VALIDATE $? "moving to app directory"

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzipping Catalogue"

cd /app &>> $LOGFILE

VALIDATE $? "moving to app directory"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies" 

#use absolute path for catalogue.service

cp /home/centos/roboshop-shell/catalogue.service  /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copying catalogue service file to systemd"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "System daemon-reloaded"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling Catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting Catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copying mongodb repo"

dnf install mongodb-org-shell -y  &>> $LOGFILE

VALIDATE $? "Installing mongodb client"

mongo --host 172.31.21.158 </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading Catalogue Data into MongoDB"









