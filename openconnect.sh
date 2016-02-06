#!/bin/bash

sudo apt-get install gnutls-bin openconnect libwww-perl

sudo mkdir -p /etc/vpnc/post-connect.d/
sudo dpkg -l resolvconf &>/dev/null \
  && echo "echo 'options ndots:2' | resolvconf -a lo.inet.vpn" \
  | sudo tee /etc/vpnc/post-connect.d/max
sudo dpkg -l resolvconf &>/dev/null \
  || echo "echo 'options ndots:2' >> /etc/resolv.conf" \
  | sudo tee /etc/vpnc/post-connect.d/max
sudo mkdir -p /etc/vpnc/disconnect.d/
sudo dpkg -l resolvconf &>/dev/null \
  && echo 'resolvconf -d lo.inet.vpn' \
  | sudo tee /etc/vpnc/disconnect.d/max
sudo dpkg -l resolvconf &>/dev/null \
  || echo "grep -v 'options ndots' /etc/resolv.conf | cat > /etc/resolv.conf" \
  | sudo tee /etc/vpnc/disconnect.d/max
sudo mkdir -p /etc/pkcs11/modules/
echo module:/usr/lib/x86_64-linux-gnu/opensc-pkcs11.so | sudo tee /etc/pkcs11/modules/opensc.module


sudo cp ~/devsetup/certs/MAX_VPN_CA.pem /usr/local/etc/


FIREFOX_SEC_DB_DIR=$(find $HOME/.mozilla/firefox -name '*.default')
echo "user_pref(\"network.proxy.autoconfig_url\",\"file:///home/`whoami`/.proxy.pac\");" >>  $FIREFOX_SEC_DB_DIR/prefs.js
echo "user_pref(\"network.proxy.type\", 2);" >> $FIREFOX_SEC_DB_DIR/prefs.js

certutil -A -n EOP_Root_CA -i ~/devsetup/certs/EOP_Root_CA.pem -d $FIREFOX_SEC_DB_DIR -t "T,,"
certutil -A -n WHCA_Root_CA -i ~/devsetup/certs/WHCA_Root_CA.pem -d $FIREFOX_SEC_DB_DIR -t "T,,"
certutil -A -n EOP_Proxy_CA -i ~/devsetup/certs/EOP_Proxy_CA.pem -d $FIREFOX_SEC_DB_DIR -t "T,,"

