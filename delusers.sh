tail -5 /etc/passwd | awk -F: '{print $1}' | while read tasks

do 

login=`echo $tasks | awk '{print $1}'`
fname=`echo $tasks | awk '{print $2 " " $3}'`
echo "$login:School@2" > passwd.txt

sleep 2

echo "Creating a user account for" $login

userdel -r $login

done