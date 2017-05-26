#!/usr/bin/env bash
systemctl stop firewalld
systemctl mask firewalld
yum -y install iptables-services
systemctl enable iptables
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1
sysctl -p
iptables -X
iptables -F
iptables -t nat -X
iptables -t nat -F
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
service iptables save
