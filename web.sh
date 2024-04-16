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

dnf install nginx -y &>>$LOGFILE

VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "Enable nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "Deleted Default Content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $? "Download web application"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "Goto html page" 

unzip -o /tmp/web.zip &>>$LOGFILE

VALIDATE $? "Unzipping Web"
 
cp /home/centos/roboshop-shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>$LOGFILE
 
VALIDATE $? "roboshop configuration"

systemctl restart nginx  &>>$LOGFILE

VALIDATE $? "nginx restart"




