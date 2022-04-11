FROM local/centos7

MAINTAINER "Buydomains newfold" <selvam.kuppuswamy@newfold.com>
LABEL author="Selvam K <selvam.kuppuswamy@newfold.com>"

RUN yum -y update && yum clean all
# Installing Build tools for PHP and Apache installation from source.
RUN  yum -y install wget
RUN  yum -y install epel-release
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN  yum -y install yum-utils

# Web Server Apache HTTPD installation and configuratioin.
RUN yum -y install httpd; yum clean all; systemctl enable httpd.service

RUN yum -y install libicu
RUN yum -y install libicu-devel

RUN yum-config-manager --enable remi-php56
RUN yum -y install php56 php56-php-cli php56-php-fpm php56-php-intl php56-php-php-devel php56-php-mysqlnd php56-php-zip php56-php-gd php56-php-mcrypt php56-php-mbstring php56-php-curl php56-php-xml php56-php-pear php56-php-bcmath php56-php-json php56-php-pdo php56-php-pecl-memcached php56-php-pecl-apcu-devel

RUN yum-config-manager --enable remi-php73
RUN yum -y  install php73 php73-php-cli php73-php-fpm php73-php-intl php73-php-devel php73-php-mysqlnd php73-php-zip php73-php-devel php73-php-gd php73-php-mcrypt php73-php-mbstring php73-php-curl php73-php-xml php73-php-pear php73-php-bcmath php73-json php73-php-pdo php73-php-pecl-memcached php73-php-pecl-apcu-devel

RUN yum-config-manager --enable remi-php80
RUN yum -y  install php80 php80-php-cli php80-php-fpm php80-php-intl php80-php-devel php80-php-mysqlnd php80-php-zip php80-php-devel php80-php-gd php80-php-mcrypt php80-php-mbstring php80-php-curl php80-php-xml php80-php-pear php80-php-bcmath php80-php-json php80-php-pdo php80-php-pecl-memcached php80-php-pecl-apcu-devel

RUN mkdir -p "/etc/httpd/ssl-certificates"
# Setting default PHP version 7.3
COPY httpd/ssl-certificates/ssl73.conf /etc/httpd/conf.d/ssl.conf
COPY httpd/ssl-certificates /etc/httpd/ssl-certificates

# Copy all fcgi files and changes owner and permission
COPY httpd/fcgi/php56.fcgi /var/www/cgi-bin
RUN chown apache:apache /var/www/cgi-bin/php56.fcgi
RUN chmod 755 /var/www/cgi-bin/php56.fcgi

COPY httpd/fcgi/php73.fcgi /var/www/cgi-bin
RUN chown apache:apache /var/www/cgi-bin/php73.fcgi
RUN chmod 755 /var/www/cgi-bin/php73.fcgi

COPY httpd/fcgi/php80.fcgi /var/www/cgi-bin
RUN chown apache:apache /var/www/cgi-bin/php80.fcgi
RUN chmod 755 /var/www/cgi-bin/php80.fcgi

# SSL certification installation and configuration.
RUN  yum -y install openssl
RUN  yum -y install mod_ssl
RUN  yum -y install httpd-tools
RUN  yum -y install expect
# Copy script that generates SSL certificate
COPY generate_certificate.exp /generate_certificate.exp

# Generate SSL certificate
RUN chmod +x /generate_certificate.exp \
 && ./generate_certificate.exp \
 && cp ca.crt /etc/pki/tls/certs \
 && cp ca.key /etc/pki/tls/private/ca.key \
 && cp ca.csr /etc/pki/tls/private/ca.csr

# Enable and expose ports outside world.
EXPOSE 80 443

COPY switch-php.sh /tmp
RUN chmod 755 /tmp/switch-php.sh

CMD ["/usr/sbin/init"]