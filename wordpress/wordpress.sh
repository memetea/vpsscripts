#!/bin/bash

yum install nginx,php-ftp,php,php-sqlite3
yum install unzip

cp ./default.conf /etc/nginx/conf.d/default.conf

cd /var/www
wget http://wordpress.org/latest.zip
unzip latest.zip
cd wordpress/wp-content/plugins
wget https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip
unzip sqlite-integration.1.8.1.zip
cp sqlite-integration/db.php ../db.php
cd /var/www/wordpress
cp wp-config-sample.php wp-config.php
chown -R nginx:nginx wordpress

mkdir /var/wordpressdata
chown -R nginx:nginx /var/wordpressdata

