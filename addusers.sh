cat users.txt | while read tasks

do 

login=`echo $tasks | awk '{print $1}'`
fname=`echo $tasks | awk '{print $2 " " $3}'`
echo "$login:School@2" > passwd.txt

sleep 2

echo "Creating a user account for" $login

useradd -c "$fname" -d /home/$login $login

echo "$login:WbDPy7E7eXHpo" | chpasswd

echo "An account has been created for" $login "with a temporal password of" `cat passwd.txt | awk -F: '{print $2}'`

chage -d 0 $login

sleep 3

echo $login "must change his/her password during his first login"

rm -f passwd.txt

done
