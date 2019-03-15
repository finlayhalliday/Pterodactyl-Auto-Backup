echo "Do you want to setup AutoBackup For Pterodactyl? (Y/N)"
dpkg -s wget &> /dev/null

if [ $? -eq 0 ]; then
    echo ""
else
    apt install -y wget
fi

if [! -d "~/scripts" ]; then
	mkdir ~/scripts

fi
wget -p ~/scripts 
chmod +x ~/scripts/autoBackup.sh
while true; do
	read continue

	if [$continue -e "Y"]; then
		ssh-keygen
		echo ""
		echo "Please enter your backup server's IP/Hostname"
		read host
		ssh-copy-id -i ~/.ssh/id_rsa.pub $host
		echo ""
		echo "Do you want to setup a Cron Job? (Y/N)"
		while true; do
			read continue

			if [$continue -e "Y"]; then
				crontab -l > cron
				echo "00 00 * * * ~/scipts/autoBackup.sh" >> cron
				crontab cron
				rm cron
				echo "Fully setup AutoBackup For Pterodactyl, exiting!"
				exit 1
			elif [$continue -e "N"]; then
				exit 1
			else
				echo "Please Enter Y or N"
			fi
	elif [$continue -e "N"]; then
		exit 1
	else
		echo "Please Enter Y or N"
	fi
done;