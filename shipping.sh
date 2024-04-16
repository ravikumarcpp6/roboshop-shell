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

dnf install maven -y

id roboshop
if [ $? -ne 0 ]
    then 
        useradd roboshop 
        VALIDATE $? "ROBOSHOP USER Creation"
    else
         echo -e "$R ROBOSHOP USER ALREADY EXIST....$Y SKIPPING... $N"    
fi 

mkdir -p /app &>> $LOGFILE 

VALIDATE $? "app Directory creation"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

VALIDATE $? "Download Shipping Application"

cd /app &>> $LOGFILE

VALIDATE $? "Moving to app directory"

unzip -o /tmp/shipping.zip &>> $LOGFILE

VALIDATE $? "Moving to app directory"

VALIDATE $? "Unzipping the shipping file"

cd /app &>> $LOGFILE

VALIDATE $? "Moving to app directory"

mvn clean package &>> $LOGFILE

VALIDATE $? "Installing Dependencies"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE

VALIDATE $? "Renaming JAR FILE"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "copying shipping service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "shipping daemon-reloaded"

systemctl enable shipping &>> $LOGFILE

VALIDATE $? "Enabling shipping"

systemctl start shipping &>> $LOGFILE

VALIDATE $? "Starting shipping"

dnf install mysql -y &>>$LOGFILE &>> $LOGFILE

VALIDATE $? "Installing Mysql"

mysql -h mysql.devopspractice.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "Load Schema"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "Restarting shipping"