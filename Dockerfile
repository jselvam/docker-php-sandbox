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

RUN yum -y install php73 php73-php-fpm php73-mysqlnd php73-zip php73-devel php73-gd php73-mcrypt php73-mbstring php73-curl php73-xml php73-pear php73-bcmath php73-json php73-pdo php73-pecl-memcached php73-pecl-apcu-devel
RUN yum -y install php56 php56-php-fpm php56-mysqlnd php56-zip php56-devel php56-gd php56-mcrypt php56-mbstring php56-curl php56-xml php56-pear php56-bcmath php56-json php56-pdo php56-pecl-memcached php56-pecl-apcu-devel
RUN yum -y install php80 php80-php-fpm php80-mysqlnd php80-zip php80-devel php80-gd php80-mcrypt php80-mbstring php80-curl php80-xml php80-pear php80-bcmath php80-json php80-pdo php80-pecl-memcached php80-pecl-apcu-devel

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