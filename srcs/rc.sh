#!/bin/bash
apt-get install -y lsb-release
apt-get install -y debconf-utils
apt-get update
expect -c "
    set timeout 10
    spawn dpkg -i mysql-apt-config_0.8.14-1_all.deb
    expect \"Which MySQL product do you wish to configure?\"
    send \"1\r\"
    expect \"Which server version do you wish to receive?\"
    send \"1\r\"
    expect \"Which MySQL product do you wish to configure?\"
    send \"4\r\"
    expect EOF
 "
export DEBIAN_FRONTEND=noninteractive
# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
apt-get update
apt-get install -y mysql-server
service nginx start
service php7.3-fpm start
service mysql start
mysql -uroot -proot -e "CREATE DATABASE www"
mysql -uroot -proot -e "CREATE USER 'www'@'localhost' IDENTIFIED BY 'www'"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'www'@'localhost'"
mysql -uwww -pwww  www < wordpress.sql
bin/bash

