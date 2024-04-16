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

dnf module disable mysql -y &>>$LOGFILE

VALIDATE $? "mysql disabled"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "mysql repo copying"

dnf install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "Installing mysql community server"

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "mysql Enabling"

systemctl start mysqld &>>$LOGFILE

VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "Setting Root Password"