#!/bin/bash

ID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "The script started executing at:$TIMESTAMP" &>> $LOGFILE

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading cart application" 

cd /app &>> $LOGFILE

VALIDATE $? "Moving to app directory"

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping cart"

cd /app &>> $LOGFILE

VALIDATE $? "Moving to app Directory"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies" 

#use absolute path for cart.service

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Cart daemon-reloaded"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart"












