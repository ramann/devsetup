#!/bin/bash

# Add one IP to the list of split tunnel
add_ip ()
{
	export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_ADDR=$1
        export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASK=255.255.0.0
        export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASKLEN=16
        export CISCO_SPLIT_INC=$(($CISCO_SPLIT_INC + 1))
}

# Initialize empty split tunnel list
export CISCO_SPLIT_INC=0

# Delete DNS info provided by VPN server to use internet DNS
# Comment following line to use DNS beyond VPN tunnel
rm /tmp/vpn-ip4-dns.*
echo "$INTERNAL_IP4_DNS" > $(mktemp -p /tmp vpn-ip4-dns.XXXXXX)
unset INTERNAL_IP4_DNS

if grep -e "$VPNGATEWAY" <(echo "$(dig +short access1.max.gov)") 
then
 	add_ip 10.11.0.0
elif grep -e "$VPNGATEWAY" <(echo "$(dig +short access3.max.gov)")
then
 	add_ip 172.24.0.0
 	add_ip 172.25.0.0
fi

# Execute default script
. /usr/share/vpnc-scripts/vpnc-script

# End of script
