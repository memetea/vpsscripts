#!/bin/bash

yum install git zlib-devel openssl-devel

#wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/code/master/vm_check.sh && bash vm_check.sh
rpm -ivh http://soft.91yun.org/ISO/Linux/CentOS/kernel/kernel-firmware-2.6.32-504.3.3.el6.noarch.rpm
rpm -ivh http://soft.91yun.org/ISO/Linux/CentOS/kernel/kernel-2.6.32-504.3.3.el6.x86_64.rpm --force
wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh


git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
./configure
make 
make install

mkdir /etc/shadowsocks-libev
copy config.json /etc/shadowsocks-libev/config.json
copy shadowsocks-libev /etc/init.d/shadowsocks-libev
chmod u+x /etc/init.d/shadowsocks-libev
/sbin/chkconfig --add shadowsocks-libev
/etc/init.d/shadowsocks-libev start

iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${shadowsocksport} -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${shadowsocksport} -j ACCEPT

/etc/init.d/iptables save
/etc/init.d/iptables restart

rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate 1.cn.pool.ntp.org