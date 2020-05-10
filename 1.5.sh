#!/bin/bash
##Passwdmanager by N.Phipps

dir=~/.passwdmanager
if [ "$1" != "" ]
then
dir=$1
fi
mkdir -p $dir
touch $dir/0.passwd
touch $dir/0.check
touch $dir/0.len
touch $dir/0.salt
printf "Welcome to passwdmanager V1.5\n"
printf "Your saved passwords:\n"
cat $dir/*.passwd
echo
printf " Add password(1)\n retreive(2)\n delete(3)\n backup(4)\n recover(5)\n"
read inp
if [ "$inp" == "1" ]
then
printf "Creating new password\n"
printf "Enter name for password:"
read name
printf "Enter your password used for getting the password again\n"
passwdm=$(mkpasswd -m SHA-512)
salt=$(echo "$passwdm"|cut -d "$" -f 3)
passwordf=$(echo "$passwdm"|cut -d "$" -f 4)
printf "Enter password length(max: 80):"
read len
passwordu=${passwordf:0:$len}
passwordcheck=${passwordf:50:2}
echo "$salt" > $dir/$name.salt
echo "$len" > $dir/$name.len
echo "$passwordcheck" > $dir/$name.check
echo "$name" > $dir/$name.passwd
printf "Your password is: \"$passwordu\" \nfor $name \n"
fi

if [ "$inp" == "2" ]
then
printf "Reading password\n"
printf "Enter password name:"
read name
salt=$(cat $dir/$name.salt)
len=$(cat $dir/$name.len)
printf "Enter your password used for getting the password again\n"
passwdm=$(mkpasswd -S $salt -m SHA-512)
passwordf=$(echo "$passwdm"|cut -d "$" -f 4)
passwordu=${passwordf:0:$len}
passwordcheck=${passwordf:50:2}
if [ "$passwordcheck" == "$(cat $dir/$name.check)" ]
then
printf "Your password is: \"$passwordu\" \nfor $name \n"
else
printf "We've detected a wrong retrival password\n"
printf "if this is an error, your password is \"$passwordu\"\n"
fi
fi

if [ "$inp" == "3" ]
then
printf "Enter name for password to delete:"
read name
printf "Are you sure you want to DELETE the password(this action cannot be undone) (y/n)\n"
read yn
if [ $yn == "y" ]
then
rm -f $dir/$name.*
else
printf "cancelled"
fi
fi

if [ "$inp" == "4" ]
then
printf "Creating backup\n"
printf "Enter backup location(cannot use ~, without / on the end):"
read location
mkdir $location/passwdmanager-backup
cp -r $dir/* $location/passwdmanager-backup/
fi

if [ "$inp"  == "5" ]
then
printf "Recovering from backup\n"
printf "Enter backup location(the passwordmanager-backup directory):"
read location
cp -r $location/* $dir/
fi
printf "Press \"c\" to leave log or anything else to clear log\e[05m \n...\e[0m\n"
read clr
if [ "$clr" != "c" ]
then
clear
clear
clear
clear
clear
fi
