#!/bin/bash
F="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz"
Aurl="http://downloads.zend.com/guard/6.0.0/"
if [[ `uname -m` == "x86_64" ]];then
        F="ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz"
fi
if [ ! -f $F ];then
	wget -c $Aurl/$F
fi
tar zxvf $F
[ $? != 0 ] && echo "file err" && exit
if [ ! -d /www/wdlinux/Zend/lib ];then
	mkdir -p /www/wdlinux/Zend/lib
fi
if [[ `uname -m` == "x86_64" ]];then
	cp ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/*.so /www/wdlinux/Zend/lib/
else
	cp ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386/php-5.4.x/*.so /www/wdlinux/Zend/lib/
fi
grep '\[Zend\]' /www/wdlinux/apache_php/etc/php.ini
if [ $? != 0 -a -f /www/wdlinux/apache_php/etc/php.ini ];then
echo '[Zend]
zend_extension = /www/wdlinux/Zend/lib/ZendGuardLoader.so
zend_loader.enable = 1' >> /www/wdlinux/apache_php/etc/php.ini
fi
grep '\[Zend\]' /www/wdlinux/nginx_php/etc/php.ini
if [ $? != 0 -a -f /www/wdlinux/nginx_php/etc/php.ini ];then
echo '[Zend]
zend_extension = /www/wdlinux/Zend/lib/ZendGuardLoader.so
zend_loader.enable = 1' >> /www/wdlinux/nginx_php/etc/php.ini
fi
echo
echo "ZendGuardLoader is OK"
