#!/bin/sh
# usage: sudo bash -x firewall.sh eth0

iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

add_rules()
{
	# outgoing DNS
	iptables -A OUTPUT -o $1 -p udp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT -i $1 -p udp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT
	iptables -A OUTPUT -o $1 -p tcp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT -i $1 -p tcp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT

	# outgoing ICMP
	iptables -A OUTPUT -o $1 -p icmp -j ACCEPT
	iptables -A INPUT -i $1 -p icmp -j ACCEPT

	# outgoing HTTP
	iptables -A OUTPUT -o $1 -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT -i $1 -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
	
	# outgoing HTTPS
	iptables -A OUTPUT -o $1 -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
	iptables -A INPUT -i $1 -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

        # outgoing HTTPS
        iptables -A OUTPUT -o $1 -p udp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        iptables -A INPUT -i $1 -p udp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
	
	iptables -A OUTPUT -o $1 -p tcp --dport 9418 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        iptables -A INPUT -i $1 -p tcp --sport 9418 -m conntrack --ctstate ESTABLISHED -j ACCEPT

        iptables -A OUTPUT -o $1 -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        iptables -A INPUT -i $1 -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

        iptables -A OUTPUT -o $1 -p tcp --dport 8888 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        iptables -A INPUT -i $1 -p tcp --sport 8888 -m conntrack --ctstate ESTABLISHED -j ACCEPT
}

add_rules $1
add_rules tun0
#add_rules enx026861790c60

iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

iptables -A OUTPUT -o $1 -p udp --sport 68 --dport 67 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $1 -p udp --sport 67 --dport 68 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o $1 -p udp --dport 500 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $1 -p udp --sport 500 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o $1 -p udp --dport 4500 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $1 -p udp --sport 4500 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o $1 -p udp --dport 993 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $1 -p udp --sport 993 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o $1 -p tcp --dport 993 -j ACCEPT
iptables -A INPUT -i $1 -p tcp --sport 993 -j ACCEPT

iptables -A OUTPUT -o $1 -p tcp --dport 587 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $1 -p tcp --sport 587 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o $1 -p tcp --dport 587 -j ACCEPT
iptables -A INPUT -i $1 -p tcp --sport 587 -j ACCEPT

iptables -A OUTPUT -o $1 -p tcp --dport 43 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $1 -p tcp --sport 43 -m conntrack --ctstate ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o tun0 -p tcp --dport 8080 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i tun0 -p tcp --sport 8080 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# log dropped connections
iptables -A INPUT -j LOG  --log-prefix "IN-DROPPED "
iptables -A OUTPUT -j LOG  --log-prefix "OUT-DROPPED "
