#!/bin/bash
if [ ! -e ~/.pin ]
then
	touch ~/.pin
	chmod 600 ~/.pin
	echo -n "Enter smartcard PIN: "
	read line
	echo "$line" > ~/.pin
fi

(cat ~/.pin ; echo "AOMB") | sudo openconnect --base-mtu=$(ip link | grep ' UP ' | head -1 | awk '{print $5}') --cafile=/usr/local/etc/MAX_VPN_CA.pem -c 'pkcs11:id=%01' -s ~/devsetup/split.sh https://access3.max.gov/
