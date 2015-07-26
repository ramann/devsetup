#!/bin/bash

# work on sudo and | sudo tee ...
# openssl x509 -in <(openssl s_client -showcerts -connect vpn.max.gov:443 2>/dev/null) > vpn.max.gov.pem
# openssl x509 -in <(openssl s_client -showcerts -connect access1.max.gov:443 -CAfile ~/vpn.max.gov.pem 2>/dev/null) > access1.max.gov.pem
# openssl x509 -in <(openssl s_client -showcerts -connect access.test.max.gov:443 -CAfile ~/vpn.max.gov.pem 2>/dev/null) > access.test.max.gov.pem

# iptables -t nat -D PREROUTING -d 96.26.96.247 -p udp --dport 500 -j DNAT --to 192.168.122.226:500
# iptables -D FORWARD -d 192.168.122.226/32 -p udp -m state --state NEW -m udp --dport 500 -j ACCEPT
# iptables -t nat -D PREROUTING -d 96.26.96.247 -p udp --dport 4500 -j DNAT --to 192.168.122.226:4500
# iptables -D FORWARD -d 192.168.122.226/32 -p udp -m state --state NEW -m udp --dport 4500 -j ACCEPT

# iptables -t nat -A PREROUTING -d 96.26.96.247 -p udp --dport 500 -j DNAT --to 192.168.122.226:500
# iptables -I FORWARD -d 192.168.122.226/32 -p udp -m state --state NEW -m udp --dport 500 -j ACCEPT
# iptables -t nat -A PREROUTING -d 96.26.96.247 -p udp --dport 4500 -j DNAT --to 192.168.122.226:4500
# iptables -I FORWARD -d 192.168.122.226/32 -p udp -m state --state NEW -m udp --dport 4500 -j ACCEPT


sudo apt-get -y install strongswan strongswan-plugin-pkcs11
sudo sh -c "echo 'manual' >> /etc/init/strongswan.override"
mv /etc/strongswan.d/charon/pkcs11.conf /etc/strongswan.d/charon/pkcs11.conf.ORIG
echo -e "pkcs11 {
  load = yes
  modules {
    opensc {
      path = /usr/lib/i386-linux-gnu/opensc-pkcs11.so
      }
    }
  }" > /etc/strongswan.d/charon/pkcs11.conf
mv /etc/apparmor.d/local/usr.lib.ipsec.charon /etc/apparmor.d/local/usr.lib.ipsec.charon.ORIG
echo -e "/usr/lib/i386-linux-gnu/opensc-pkcs11.so rm,
/etc/opensc/opensc.conf r,
/run/pcscd/pcscd.comm rw," >> /etc/apparmor.d/local/usr.lib.ipsec.charon
sudo apparmor_parser -r /etc/apparmor.d/usr.lib.ipsec.charon
echo ": PIN %smartcard:1 %prompt" >> /etc/ipsec.secrets
mv /etc/ipsec.conf /etc/ipsec.conf.ORIG
echo "conn base
  keyexchange=ikev1
  ike=aes256-sha1-modp1536
  esp=aes256-sha1
  leftcert=%smartcard:1
  leftsourceip=%modecfg
  rightsubnet=0.0.0.0/0
conn max1
  also=base
  auto=add
  right=access1.max.gov
  rightid=\"C=US, ST=District of Columbia, L=Washington, O=Office of Management and Budget, CN=access1.max.gov\"
conn max2
  also=base
  auto=add
  right=access2.max.gov
  rightid=\"C=US, ST=District of Columbia, L=Washington, O=Office of Management and Budget, CN=access1.max.gov" > /etc/ipsec.conf
echo "function FindProxyForURL(url, host) {
  if (dnsResolve(\"webproxy.internal.max.gov\") != null) {
    return \"PROXY webproxy.internal.max.gov:8080\";
  }
  return \"DIRECT\";
}" > $HOME/.proxy.pac

#sudo ipsec start ; sleep 5 ; sudo ipsec rereadsecrets ; sudo ipsec up max1 ; echo "search internal.max.gov" | sudo resolvconf -a lo.inet.ipsec
#sudo ipsec down max1 ; sudo ipsec stop ; sudo resolvconf -d lo.inet.ipsec
