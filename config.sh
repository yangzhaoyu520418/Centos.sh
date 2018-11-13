#!/bin/bash
# author for yangzhaoyu 2018.11.13
# use LAMP_config script

load_config(){
	apache_location=/user/local/apache
	mysql_location=/usr/local/mysql
	mariadb_location=/usr/local/mysql
	percona_location=/usr/local/percona
	php_location=/usr/local/php
	openssl_localtion=/usr/local/openssl
	deoends_prefix=/usr/local
	web_root_dir=/data/www/default
	download_root_dir="https://dl.lamp.sg.files"
	parallel_compile=1
	#nghttp2
	nghttp2_filename="nghttp2-1.34.0"
	#openssl
	openssl_filename="openssl-1.0.2p"
	#apache2.4
	apache2_4_filename="httpd-2.4.37"
	#mysql5.5
	mysql5_5_filename="mysql-5.5.62"
	#mysql5.6
	mysql5_6_filename="mysql-5.6.42"
	#mysql5.7
	mysql5_7_filename="mysql-5.7.24"
	#mysql8.0
	mysql8_0_filename="mysql-8.0.13"
	#mariadb5.5
	mariadb5_5_filename="mariadb-5.5.62"
	#mariadb10.0
	mariadb10_0_filename="mariadb-10.0.37"
	#mariadb10.1
	mariadb10_1_filename="mariadb-10.1.37"
	#mariadb10.2
	mariadb10_2_filename="mariadb-10.2.18"
	#mariadb10.3
	mariadb10_3_filename="mariadb-10.3.10"
	#percona5.5
	percona5_5_filename="Percona-Server-5.5.61-38.13"
	#percona5.6
	percona5_6_filename="Percona-Server-5.6.41-84.1"
	#percona5.7
	percona5_7_filename="Percona-Server-5.7.23-23"
	#php5.6
	php5_6_filename="php-5.6.38"
	#php7.0
	php7_0_filename="php-7.0.32"
	#php7.1
	php7_1_filename="php-7.1.24"
	#php7.2
	php7_2_filename="php-7.2.12"
	#phpMyAdmin
	phpmyadmin_filename="phpMyAdmin-4.8.3-all-languages"
	kod_version=$(wget --no-check-certificate -qO- https://api.github.com/repos/kalcaddle/kodfile/releases/latest | grep 'tag_name' | cut -d\" -f4)
	[ -z "$kod_version"  ] && kod_version="4.35"
	set_hint ${kodexplorer_filename} "kodexplorer-${kod_version}"
	 
}


