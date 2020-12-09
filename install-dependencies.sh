#!/bin/sh
set -eux
	
if command -v a2enmod; then 
    a2enmod rewrite 
fi 

savedAptMark="$(apt-mark showmanual)" 

docker-php-ext-configure gd --with-freetype --with-jpeg  

docker-php-ext-install -j "$(nproc)" gd opcache pdo_mysql pdo_pgsql zip bcmath

# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
apt-mark auto '.*' > /dev/null 
apt-mark manual $savedAptMark 
ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
    | awk '/=>/ { print $3 }' \
    | sort -u \
    | xargs -r dpkg-query -S \
    | cut -d: -f1 \
    | sort -u \
    | xargs -rt apt-mark manual \

apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
rm -rf /var/lib/apt/lists/*
#add user to normal work with user 1000 in ubuntu
useradd -u 1000 drupal
