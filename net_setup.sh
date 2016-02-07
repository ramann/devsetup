#!/bin/bash
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee --append /etc/sysctl.conf &> /dev/null
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee --append /etc/sysctl.conf &> /dev/null
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee --append /etc/sysctl.conf &> /dev/null
sudo sysctl -p -q
 
