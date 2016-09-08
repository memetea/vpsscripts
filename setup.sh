#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -n "enter your shadowsocks server port: "  
read  shadowsocksport 
echo -n "enter your shadowsocks server password: "  
read  shadowsockspwd

yum groupinstall "Development Tools"
yum install git zlib-devel openssl-devel pcre-devel

# Make sure only root can run our script
function rootness(){
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi
}

#install serverspeeder
#wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/code/master/vm_check.sh && bash vm_check.sh
#rpm -ivh http://soft.91yun.org/ISO/Linux/CentOS/kernel/kernel-firmware-2.6.32-504.3.3.el6.noarch.rpm
#rpm -ivh http://soft.91yun.org/ISO/Linux/CentOS/kernel/kernel-2.6.32-504.3.3.el6.x86_64.rpm --force
#wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh



git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
./configure
make 
make install

if [ ! -d /etc/shadowsocks-libev ];then
        mkdir /etc/shadowsocks-libev
    fi
    cat > /etc/shadowsocks-libev/config.json<<-EOF
{
    "server":"0.0.0.0",
    "server_port":${shadowsocksport},
    "password":"${shadowsockspwd}",
    "timeout":600,
    "method":"aes-128-cfb"
}
EOF

cp ${DIR}/templatefiles/shadowsocks-libev /etc/init.d/shadowsocks-libev
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
