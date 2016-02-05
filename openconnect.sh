#!/bin/sh

sudo apt-get install gnutls-bin openconnect libwww-perl

sudo -s
mkdir -p /etc/vpnc/post-connect.d/
dpkg -l resolvconf &>/dev/null \
  && echo "echo 'options ndots:2' | resolvconf -a lo.inet.vpn" \
  > /etc/vpnc/post-connect.d/max
dpkg -l resolvconf &>/dev/null \
  || echo "echo 'options ndots:2' >> /etc/resolv.conf" \
  > /etc/vpnc/post-connect.d/max
mkdir -p /etc/vpnc/disconnect.d/
dpkg -l resolvconf &>/dev/null \
  && echo 'resolvconf -d lo.inet.vpn' \
  > /etc/vpnc/disconnect.d/max
dpkg -l resolvconf &>/dev/null \
  || echo "grep -v 'options ndots' /etc/resolv.conf | cat > /etc/resolv.conf" \
  > /etc/vpnc/disconnect.d/max
mkdir -p /etc/pkcs11/modules/
echo module:/usr/lib/x86_64-linux-gnu/opensc-pkcs11.so > /etc/pkcs11/modules/opensc.module
exit


sudo cp ~/devsetup/certs/MAX_VPN_CA.pem /usr/local/etc/
