#!/bin/bash
DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

yum install php-fpm php php-sqlite3 unzip

if [ ! -f /etc/nginx/conf.d/default.conf ]; then
	yum install nginx
	cp ${DIR}/default.conf /etc/nginx/conf.d/default.conf
        cp ${DIR}/www.conf /etc/php-fpm.d/www.conf
fi

if [ ! -d /var/www/wordpress ]; then
	cd /var/www
	wget http://wordpress.org/latest.zip
	echo 'unziping wordpress'
	unzip latest.zip > /dev/null
	cd /var/www/wordpress
	cp wp-config-sample.php wp-config.php
	chown -R nginx:nginx wordpress
	cp ${DIR}/default.conf /etc/nginx/conf.d/default.conf
fi

if [ ! -d /var/www/wordpress/wp-content/plugins/sqlite-integration ]; then
	cd /var/www/wordpress/wp-content/plugins
	wget https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip
	echo 'unziping sqlite-integration'
	unzip sqlite-integration.1.8.1.zip > /dev/null
	cp sqlite-integration/db.php ../db.php
fi

if [ ! -d /var/wordpressdata ]; then
	mkdir /var/wordpressdata
	chown -R nginx:nginx /var/wordpressdata
fi

iptables -I INPUT -m state --state NEW -m tcp -p tcp  --dport 80 -j ACCEPT

/etc/init.d/iptables save
/etc/init.d/iptables restart
