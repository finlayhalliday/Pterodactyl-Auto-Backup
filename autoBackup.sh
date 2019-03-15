#!/bin/bash

dpkg -s dnsutils &> /dev/null

if [ $? -eq 0 ]; then
    echo ""
else
    apt install -y dnsutils
fi

dpkg -s rsync &> /dev/null

if [ $? -eq 0 ]; then
    echo ""
else
    apt install -y rsync
fi

export GZIP=-9

local_backup=$false

ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
server_1="127.0.0.1"
server_2="127.0.0.1"
server_3="127.0.0.1"
server_4="127.0.0.1"
server_5="127.0.0.1"
server_6="127.0.0.1"

backup_server="1.2.3.4"

date=$(date +'%m-%d-%Y')

daemon-dir="/srv/daemon-data"


if [ -d "$daemon-dir" ]; then
    cd $daemon-dir
    if [!$local_backup]; then
        if [[ $ip == $backup_server ]]; then
            tar cvzf ./$date.tar.gz $daemon-dir
            rsync -a $daemon-dir/$date.tar.gz /backup/backup_server/
            rm ./$date.tar.gz
        elif [[ $ip == $server_1 ]]; then
            tar cvzf ./$date.tar.gz $daemon-dir
            rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $daemon-dir/$date.tar.gz root@$backup_server:/backup/Server_1/
            rm ./$date.tar.gz
        elif [[ $ip == $server_2 ]]; then
            tar cvzf ./$date.tar.gz $daemon-dir
            rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $daemon-dir/$date.tar.gz root@$backup_server:/backup/Server_2/
            rm ./$date.tar.gz
        elif [[ $ip == $server_3 ]]; then
            tar cvzf ./$date.tar.gz $daemon-dir
            rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $daemon-dir/$date.tar.gz root@$backup_server:/backup/Server_3/
            rm ./$date.tar.gz
        elif [[ $ip == $server_4 ]]; then
            tar cvzf ./$date.tar.gz $daemon-dir
            rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $daemon-dir/$date.tar.gz root@$backup_server:/backup/Server_4/
            rm ./$date.tar.gz
        elif [[ $ip == $server_5 ]]; then
            tar cvzf ./$date.tar.gz $daemon-dir
            rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $daemon-dir/$date.tar.gz root@$backup_server:/backup/Server_5/
            rm ./$date.tar.gz
        elif [[ $ip == $server_6 ]]; then
            tar cvzf ./$date.tar.gz $daemon-dir
            rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $daemon-dir/$date.tar.gz root@$backup_server:/backup/Server_6/
            rm ./$date.tar.gz
        else
            echo "Current Node Not Configured"
        fi
    else
        tar cvzf ./$date.tar.gz $daemon-dir
        rsync -a $daemon-dir/$date.tar.gz /backup/
        rm ./$date.tar.gz
    fi
else
    echo "Daemon Directory ($daemon-dir) doesn't exist!"
fi

