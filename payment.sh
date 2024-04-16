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

dnf install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "Install python 3.6"

id roboshop
if [ $? -ne 0 ]
    then 
        useradd roboshop 
        VALIDATE $? "ROBOSHOP USER Creation"
    else
         echo -e "$R ROBOSHOP USER ALREADY EXIST....$Y SKIPPING... $N"    
fi 

mkdir -p /app &>>$LOGFILE

VALIDATE $? "app Directory Created"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? " Payment application downloaded to tmp"

cd /app  &>>$LOGFILE

VALIDATE $? "Move to app Directory"

unzip -o /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "Unzipping the payment"

cd /app &>>$LOGFILE

VALIDATE $? "Move to app Directroy"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "Install the Dependencies"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "Copying the Payment Service File"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "payment daemon reloaded"

systemctl enable payment &>>$LOGFILE

VALIDATE $? "Enabling Payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "Starting Payment"
