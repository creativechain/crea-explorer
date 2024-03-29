FROM ubuntu:20.04

ENV php_conf /etc/php/7.4/fpm/php.ini
ENV fpm_conf /etc/php/7.4/fpm/php-fpm.conf
ENV composer_hash 795f976fe0ebd8b75f26a6dd68f78fd3453ce79f32ecb33e7fd087d39bfeb978342fb73ac986cd4f54edd0dc902601dc

RUN apt-get update -y && apt-get install -y software-properties-common
RUN apt-get install -y php-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config
#RUN apt-add-repository ppa:phalcon/stable && apt-get update -y

RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash

RUN apt-get install -y bash \
    vim \
    openssh-client \
    wget \
    nginx \
    supervisor \
    curl \
    git \
    php7.4-dev \
    php7.4-fpm \
#    php7.4-mcrypt \
    php7.4-ctype \
    php7.4-gd \
    php7.4-intl \
    php7.4-xml \
    php7.4-xsl \
    php7.4-curl \
    php7.4-iconv \
    php7.4-json \
    php7.4-phar \
    php7.4-dom \
#    php7.4-phalcon \
    php7.4-zip \
    php-xdebug \
    php7.4-mbstring \
    ca-certificates \
    dialog \
    gcc \
    musl-dev \
    libffi-dev &&\
    mkdir -p /etc/nginx && \
    mkdir -p /var/www/app && \
    mkdir -p /run/nginx && \
    mkdir -p /var/log/supervisor

RUN pecl install mcrypt-1.0.4

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    #php -r "if (hash_file('SHA384', 'composer-setup.php') === '${composer_hash}') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /etc/nginx/ssl/ && \
    rm -Rf /var/www/*
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

RUN apt-get update && apt-get install -y php-pear libcurl4-openssl-dev pkg-config libssl-dev && \
    pecl install mongodb && \
    echo "extension=mongodb.so" > /etc/php/7.4/fpm/conf.d/30-mongo.ini && \
    echo "extension=mongodb.so" > /etc/php/7.4/cli/conf.d/30-mongo.ini

RUN apt-get install -y memcached php-memcached re2c

#RUN add-apt-repository ppa:ondrej/php
RUN pecl install phalcon-4.1.0
#RUN cp /usr/lib/php/20180731/phalcon.so /usr/lib/php/20190902/phalcon.so

# tweak php-fpm config
RUN mkdir -p /run/php &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" ${php_conf} && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" ${php_conf} && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" ${php_conf} && \
    sed -i -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" ${php_conf} && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" ${fpm_conf} && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" ${fpm_conf} && \
    sed -i -e "s/pm.max_children = 4/pm.max_children = 4/g" ${fpm_conf} && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/user = nobody/user = nginx/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/group = nobody/group = nginx/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0666/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.owner = nobody/listen.owner = nginx/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.group = nobody/listen.group = nginx/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/;php_admin_value[memory_limit] = 32M/php_admin_value[memory_limit] = 512M/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/^;clear_env = no$/clear_env = no/" /etc/php/7.4/fpm/pool.d/www.conf &&\
    sed -i -e "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini &&\
    ln -s /etc/php/7.4/fpm/php.ini /etc/php/7.4/fpm/conf.d/php.ini && \
    find /etc/php/7.4/fpm/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \; && \
    sed -i -e "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.4/fpm/conf.d/php.ini &&\
    echo "extension=phalcon.so" > /etc/php/7.4/fpm/conf.d/30-phalcon.ini && \
    echo "extension=phalcon.so" > /etc/php/7.4/cli/conf.d/30-phalcon.ini && \
    echo "extension=mcrypt.so" > /etc/php/7.4/fpm/conf.d/30-mcrypt.ini && \
    echo "extension=mcrypt.so" > /etc/php/7.4/cli/conf.d/30-mcrypt.ini

# Add Scripts
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/vhost.conf /etc/nginx/sites-enabled/default

# Services
ADD conf/supervisord.conf /etc/supervisord.conf

EXPOSE 443 80

CMD ["/start.sh"]
