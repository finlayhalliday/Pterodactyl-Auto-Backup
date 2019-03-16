#!/bin/bash
if [ $EUID -ne 0 ]; then
   echo "This script must be run as root" 
   exit 1
fi
read -p "Do you want to setup AutoBackup For Pterodactyl? (Y/N)" continue
if [ $continue == "N" ] || [ $continue == "n" ]; then
	exit 1
fi
dpkg -s wget &> /dev/null

if [ $? -eq 0 ]; then
    echo ""
else
    apt install -y wget
fi

if [ ! -d "~/scripts" ]; then
	mkdir ~/scripts

fi


if [ ! -f "~/scripts/autoBackup.sh" ]; then
	cd ~/scripts
	wget https://raw.githubusercontent.com/Kong-plays/Pterodactyl-Auto-Backup/master/autoBackup.sh
	chmod +x ~/scripts/autoBackup.sh
	cd ../
fi
cd ~/.ssh
if [ -f "~/.ssh/config" ]; then
	rm config
fi
wget https://raw.githubusercontent.com/Kong-plays/Pterodactyl-Auto-Backup/master/resources/config
cd ../


while true; do

	if [ $continue == "Y" ] || [ $continue == "y" ]; then
		ssh-keygen
		echo ""
		read  -p "Please enter your backup server's IP/Hostname: " host
		read  -p "Please enter your backup server's User: " user
		ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$host
		echo ""
		while true; do
			read -p "Do you want to setup a Cron Job? (Y/N)" continue
			if [ $continue == "Y" ] || [ $continue == "y" ]; then
				crontab -l | { cat; echo "0 0 * * * ~/scipts/autoBackup.sh"; } | crontab -
				echo "Fully setup AutoBackup For Pterodactyl, exiting!"
				~/scripts/autoBackup.sh
			elif [ $continue == "N" ] || [ $continue == "n" ]; then
				exit 1
			else
				read -p "Please Enter Y or N" continue
			fi
		done;
	elif [ $continue == "N" ] || [ $continue == "n" ]; then
		exit 1
	else
		read -p "Please Enter Y or N" continue
	fi
done;