#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

ID=$(id -u)
if [ $ID -ne 0 ]
    then 
        echo -e "$R ERROR...please run with root user $N"
    else
        echo -e "$G You are root user $N"  
fi          
