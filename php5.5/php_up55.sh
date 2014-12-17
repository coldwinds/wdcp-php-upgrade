#!/bin/bash
# PHP 5.5 update scripts
# Author: Arefly
# Url: http://www.arefly.com/

if [ ! $1 ];then
	Ver=5.5.9
else
	Ver=$1
fi

Debugfile=20121212

echo "THANK YOU FOR USING UPDATE SCRIPT MADE BY AREFLY.COM"
echo "YOU ARE GOING TO UPDATE YOUR PHP TO ${Ver}"
echo "YOU CAN JUST HAVE A REST"
echo "IT MAY TAKE A LOT OF TIME"
echo
#read -p "PRESS ENTER IF YOU REALLY WANT TO UPDATE"
read -p "DO YOU REALLY WANT TO UPDATE? (Y/N)" yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
	echo "PHP IS NOW UPDATING!"
else
	exit
fi
echo
echo "-------------------------------------------------------------"
echo

###yum
yum install -y libmcrypt-devel libjpeg-devel libpng-devel freetype-devel curl-devel openssl-devel libxml2-devel zip unzip

###
if [ ! -f php-${Ver}.tar.gz ];then
	wget -c http://us1.php.net/distributions/php-${Ver}.tar.gz
fi
if [ ! -f iconv_ins.sh ];then
	wget -c http://down.wdlinux.cn/in/iconv_ins.sh
	sh iconv_ins.sh
fi

###
if [ -f /www/wdlinux/mysql/lib/libmysqlclient.so.18 ];then
	if [ -d /usr/lib64 ];then
		LIBNCU="/usr/lib64"
	else
		LIBNCU="/usr/lib"
	fi
	ln -sf /www/wdlinux/mysql/lib/libmysqlclient.so.18 $LIBNCU
fi

tar zxvf php-${Ver}.tar.gz
cd php-${Ver}
if [ -d /www/wdlinux/apache_php ];then
echo "START CONFIGURING PHP ON NGINX"
sleep 3
make clean
	./configure --prefix=/www/wdlinux/apache_php-${Ver} --with-config-file-path=/www/wdlinux/apache_php-${Ver}/etc --with-mysql=/www/wdlinux/mysql --with-iconv=/usr --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --with-mcrypt=/usr --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-ftp --enable-sockets --enable-zip --with-apxs2=/www/wdlinux/apache/bin/apxs --with-mysqli=/www/wdlinux/mysql/bin/mysql_config --with-pdo-mysql=/www/wdlinux/mysql --enable-opcache --enable-bcmath
[ $? != 0 ] && echo "NO! CONFIGURE ERROR! TRY AGAIN OR ASK IN THE BBS! :(" && exit
echo "START MAKE"
sleep 3
make
[ $? != 0 ] && echo "NO! MAKE ERROR! TRY AGAIN OR ASK IN THE BBS! :(" && exit
echo "START MAKE INSTALL"
sleep 3
make install
[ $? != 0 ] && echo "NO! MAKE INSTALL ERROR! TRY AGAIN OR ASK IN THE BBS! :(" && exit
cp php.ini-production /www/wdlinux/apache_php-${Ver}/etc/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /www/wdlinux/apache_php-${Ver}/etc/php.ini
rm -f /www/wdlinux/apache_php
ln -sf /www/wdlinux/apache_php-${Ver} /www/wdlinux/apache_php
if [ ! -d /www/wdlinux/apache_php-${Ver}/lib/php/extensions ];then
	mkdir -p /www/wdlinux/apache_php-${Ver}/lib/php/extensions/no-debug-zts-${Debugfile}
	ln -sf /www/wdlinux/apache_php-${Ver}/lib/php/extensions/no-debug-zts-${Debugfile} /www/wdlinux/apache_php-${Ver}/lib/php/extensions/no-debug-non-zts-${Debugfile}
fi
service httpd restart
fi

if [ -d /www/wdlinux/nginx_php ];then
echo "START CONFIGURING PHP ON APACHE"
sleep 3
make clean
	./configure --prefix=/www/wdlinux/nginx_php-${Ver} --with-config-file-path=/www/wdlinux/nginx_php-${Ver}/etc --with-mysql=/www/wdlinux/mysql --with-iconv=/usr --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --with-mcrypt=/usr --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-ftp --enable-sockets --enable-zip --enable-fpm --with-mysqli=/www/wdlinux/mysql/bin/mysql_config --with-pdo-mysql=/www/wdlinux/mysql
[ $? != 0 ] && echo "NO! CONFIGURE ERROR! TRY AGAIN OR ASK IN THE BBS! :(" && exit
echo "START MAKE"
sleep 3
make
[ $? != 0 ] && echo "NO! MAKE ERROR! TRY AGAIN OR ASK IN THE BBS! :(" && exit
echo "START MAKE INSTALL"
sleep 3
make install
[ $? != 0 ] && echo "NO! MAKE INSTALL ERROR! TRY AGAIN OR ASK IN THE BBS! :(" && exit
cp php.ini-production /www/wdlinux/nginx_php-${Ver}/etc/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /www/wdlinux/nginx_php-${Ver}/etc/php.ini
service php-fpm stop
rm -f /www/wdlinux/nginx_php
ln -sf /www/wdlinux/nginx_php-${Ver} /www/wdlinux/nginx_php
cp /www/wdlinux/nginx_php-${Ver}/etc/php-fpm.conf.default /www/wdlinux/nginx_php-${Ver}/etc/php-fpm.conf
sed -i 's/user = nobody/user = www/g' /www/wdlinux/nginx_php/etc/php-fpm.conf
sed -i 's/group = nobody/group = www/g' /www/wdlinux/nginx_php/etc/php-fpm.conf
sed -i 's/;pid =/pid =/g' /www/wdlinux/nginx_php/etc/php-fpm.conf
cp -f sapi/fpm/init.d.php-fpm /www/wdlinux/init.d/php-fpm
chmod 755 /www/wdlinux/init.d/php-fpm
if [ ! -d /www/wdlinux/nginx_php-${Ver}/lib/php/extensions ];then
	mkdir -p /www/wdlinux/nginx_php-${Ver}/lib/php/extensions/no-debug-zts-${Debugfile}
	ln -sf /www/wdlinux/nginx_php-${Ver}/lib/php/extensions/no-debug-zts-${Debugfile} /www/wdlinux/nginx_php-${Ver}/lib/php/extensions/no-debug-non-zts-${Debugfile}
fi
fi
cd ..
rm -rf php-${Ver}/
rm -rf php-${Ver}.tar.gz
rm -rf iconv_ins.sh
echo
echo "-------------------------------------------------------------"
echo "PHP UPDATE FINISH! :D"
echo "NOW YOUR PHP VERSION IS ${Ver}!"
echo "UPDATE SCRIPT MADE BY AREFLY.COM"
echo "THANK YOU FOR USING"
echo
echo "WDCP (C) COPYRIGHT"
echo
echo "PS: I THINK YOU NEED RESTART SERVER AFTER UPDATE."
echo "PS2: REMEMBER TO VISIT AREFLY.COM! :D"
echo