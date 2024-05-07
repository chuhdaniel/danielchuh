#!/bin/bash

read -p "Enter User's Login Name: " login

if

  test | grep $login /etc/passwd > /dev/null

then

sleep 2

  echo "Searching for $login in the system..."

sleep 5

  echo $login "Has a User Account in this server"

elif

sleep 2

 echo "Searching for $login in the system..."

sleep 5

  echo $login "Has no Account in this Server"

sleep 2

read -p "Would you like to create one? [y/n]: " option

  [ "$option" = "y" ]

then
read -p "Enter user's full Names: " fname
read -p "Enter Home directory: " home
read -p "Enter default shell: " shell

sleep 5

echo "You are about to create a user account for" $fname
useradd -c "$fname" -d $home -s $shell -m $login

sleep 5
echo "User account created successfully..."
echo "Creating password for $login"
echo $login:School1@12 | chpasswd 
sleep 4
echo "An account has been created for" $login "with a temporal password of School1@12"
fi


