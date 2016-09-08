#!/bin/bash

cd ~

if [ ! -d /root/.dropbox-dist ]; then
	osbits=$(getconf LONG_BIT)
	if osbits=64; then
	    wget -O dropbox.tar.gz "https://www.dropbox.com/download?plat=lnx.x86_64" 
	else
	    wget -O dropbox.tar.gz  "https://www.dropbox.com/download?plat=lnx.x86" 
	fi
	tar zxf dropbox.tar.gz
	#link to your account
	.dropbox-dist/dropboxd
fi

if [ ! -f dropbox.py ]; then
	wget -O dropbox.py https://www.dropbox.com/download?dl=packages/dropbox.py
	chmod u+x dropbox.py
fi

#exclude sync
#./dropbox.py exclude add /root/Dropbox/doc


#files to backup
cd ~/Dropbox/backup
ln -s /var/wordpressdata/wp.db

