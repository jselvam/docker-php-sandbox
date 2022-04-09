#!/bin/sh
echo "Enter one of the following PHP version \n"
echo "56\n"
echo "73\n"
echo "80\n"

if [ "$1" = "" ]; then
    echo "Switch the currently active PHP version of phpfarm (No space or dot allowed)"
    echo "Available PHP versions: 5.6, 7.3, 8.0 only"
    exit 1
fi

if [ ! -e "/etc/httpd/ssl-certificates/ssl$1.conf" ]; then
    echo "PHP version ssl$1.conf SSL configuration is missing.  (Please add new file in docker/httpd/ssl-certificates)"
    exit 2
fi

if [ ! -e "/var/www/cgi-bin/php$1.fcgi" ]; then
    echo "PHP version php$1.fcgi configuration is missing. (Please add new file in docker/httpd/fcgi)"
    exit 2
fi

default_ssl_file="/etc/httpd/conf.d/ssl.conf"
ssl_file_new="/etc/httpd/ssl-certificates/ssl$1.conf"

cp "$ssl_file_new" "$default_ssl_file"

systemctl restart php73-php-fpm
systemctl restart php56-php-fpm
systemctl restart php80-php-fpm
systemctl restart httpd
