FROM debian:buster

RUN apt-get update
EXPOSE 80 443
RUN apt-get install -y gnupg
RUN apt-get install -y ufw
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y expect
RUN apt-get install -y nginx
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN curl -LO https://wordpress.org/latest.tar.gz
RUN apt-get -y install php7.3-fpm php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-opcache php7.3-soap php7.3-zip unzip -y
RUN tar -xvzf latest.tar.gz -C /var/www/html
RUN cp -rf /var/www/html/wordpress/* .
RUN rm -rf wordpress
RUN chown www-data: /var/www/html/wordpress/ -R
COPY wp-config-sample.ph /var/www/html
RUN tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.0.1-all-languages/ phpMyAdmin
RUN cp -rf phpMyAdmin ./var/www/html/
RUN cp -rf phpMyAdmin /usr/share/
COPY sources.list /etc/apt/
COPY default etc/nginx/sites-available/
RUN apt-get -y update
RUN apt-get -y upgrade 
COPY rc.sh ./
CMD bash rc.sh
