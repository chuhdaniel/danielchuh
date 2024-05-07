#!/bin/bash
y=`date | awk '{print $1}'`
if
    test | grep $y day > /dev/null
then
    rsync -azP /home/ /backup/myserver1/incremental
elif
    test | grep $y day1 > /dev/null
then
    mkdir /backup/myserver1/fullbackup/fb.`date +%m%d%y`
    rsync -azP /home/ /backup/myserver1/fullbackup/fb.`date +%m%d%y`
fi