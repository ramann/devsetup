#!/bin/bash

INTERNAL_IP4_DNS_ARRAY=($(cat /tmp/vpn-ip4-dns.*))
error="no servers could be reached"

for i in "${INTERNAL_IP4_DNS_ARRAY[@]}"
do
        WEB_PROXY_SET=$(grep -e "webproxy.internal.max.gov" /etc/hosts &>/dev/null ;  echo $?)
	WEB_PROXY=$(dig @$i +short webproxy.internal.max.gov)
        if [ -n $WEB_PROXY ] && [[ $WEB_PROXY != *"$error"* ]] && [ "$WEB_PROXY_SET" = "1" ]
	then
                (echo $WEB_PROXY webproxy.internal.max.gov) >> /etc/hosts
        fi

	SANDBOX_SET=$(grep -e "TL1830-APP.max.internal.max.gov" /etc/hosts &>/dev/null ;  echo $?)
        SANDBOX=$(dig @$i +short TL1830-APP.max.internal.max.gov)
        if [ ! -z $SANDBOX ] && [[ $SANDBOX != *"$error"* ]] && [ "$SANDBOX_SET" = "1" ]
        then
		(echo $SANDBOX TL1830-APP.max.internal.max.gov) >> /etc/hosts
       fi
done

