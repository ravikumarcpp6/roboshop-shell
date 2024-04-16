#!/bin/bash

ID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "The script started executing at:$TIMESTAMP" &>> $LOGFILE

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGODB_HOST=mongodb.devopspractice.shop

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

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? "Downloading user application" 

cd /app &>> $LOGFILE

VALIDATE $? "moving to app directory"

unzip -o /tmp/user.zip &>> $LOGFILE

VALIDATE $? "Unzipping user"

cd /app  &>> $LOGFILE

VALIDATE $? "MOVING to app Directory"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies" 

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>> $LOGFILE

VALIDATE $? "copying user service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "user daemon-reloaded"

systemctl enable user &>> $LOGFILE

VALIDATE $? "Enabling user"

systemctl start user &>> $LOGFILE

VALIDATE $? "Starting user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copying mongodb repo"

dnf install mongodb-org-shell -y  &>> $LOGFILE

VALIDATE $? "Installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/user.js &>> $LOGFILE

VALIDATE $? "Loading user Data into MongoDB"