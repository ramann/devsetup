#!/bin/bash
if [ ! -e ~/.pin ]
then
	touch ~/.pin
	chmod 600 ~/.pin
	echo -n "Enter smartcard PIN: "
	read line
	echo "$line" > ~/.pin
fi


# Not all gateways are equal. These are in order of reliability.
vpn_gateways=("access3.max.gov" "access1.max.gov" "access2.max.gov")

for i in "${vpn_gateways[@]}"
do
	while read line
	do
		echo $line >> /var/log/vpn.log
		if [[ $line == *"Established DTLS connection"* ]]
		then
			~/devsetup/vpn-dns.sh
		fi
	done < <((cat ~/.pin ; echo "AOMB") | sudo openconnect --base-mtu=$(ip link | grep ' UP ' | head -1 | awk '{print $5}') --cafile=/usr/local/etc/MAX_VPN_CA.pem -c 'pkcs11:id=%01' -s ~/devsetup/split.sh $i 2>&1)
done


