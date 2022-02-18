#!/bin/bash

sed -i -e "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.3/fpm/php.ini
sed -i -e "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.3/fpm/conf.d/php.ini
echo '* Working around permission errors locally by making sure that "nginx" uses the same uid and gid as the host volume'
TARGET_UID=$(stat -c "%u" /var/lib/nginx)
echo '-- Setting nginx user to use uid '$TARGET_UID
usermod -o -u $TARGET_UID nginx || true
TARGET_GID=$(stat -c "%g" /var/lib/nginx)
echo '-- Setting nginx group to use gid '$TARGET_GID
groupmod -o -g $TARGET_GID nginx || true

echo '-- Creating app cache directory'
mkdir /var/www/html/cache/volt -p
chmod 777 /var/www/html/cache -R

echo '-- Updating composer libraries'
composer -d/var/www/html install
composer -d/var/www/html update

echo '* Starting nginx'
/usr/bin/supervisord -n -c /etc/supervisord.conf
