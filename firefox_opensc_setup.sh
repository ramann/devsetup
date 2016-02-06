#!/bin/bash
date1=$(date)
sudo apt-get update
sudo apt-get -y install pcsc-tools opensc libnss3-tools

# detect the smartcard
pkcs15-tool -D &> /dev/null
result=$(echo $?)
if [ $result -ne 0 ]
then
	echo "Smartcard check failed. Make sure your reader is attached and card is properly inserted."
	exit $result
fi

firefox -CreateProfile default

# add opensc module to firefox 
FIREFOX_SEC_DB_DIR=$(find $HOME/.mozilla/firefox -name '*.default')
OPENSC_PKCS11_LIB=$(find /usr/lib -name 'opensc-pkcs11.so'| head -n 1)
modutil -dbdir $FIREFOX_SEC_DB_DIR -add opensc_pkcs11_module -libfile $OPENSC_PKCS11_LIB


url1=$(pkcs15-tool --read-certificate 01 | openssl x509 -text | grep "CA Issuers" | grep "//keys.eop.gov" | awk -F 'URI:' '{print $2}')
curl $url1 | openssl pkcs7 -inform DER -print_certs -out 1.pem
url2=$(openssl x509 -noout -text -in 1.pem | grep "CA Issuers" | grep "//keys.eop.gov" | awk -F 'URI:' '{print $2}')
curl $url2 | openssl pkcs7 -inform DER -print_certs -out 2.pem
certutil -A -n $(basename $url1) -i 1.pem -d $FIREFOX_SEC_DB_DIR -t "T,T,T"
certutil -A -n $(basename $url2) -i 2.pem -d $FIREFOX_SEC_DB_DIR -t "T,T,T"

date2=$(date)
echo "start: $date1"
echo "finish: $date2"
