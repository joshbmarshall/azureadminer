FROM debian:9-slim

RUN apt-get update \
 && apt-get -y upgrade

RUN apt-get install -y wget curl apt-transport-https \
 && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
 && echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list \
 && apt-get update \
 && apt-get install -y php7.3 php7.3-dev php7.3-xml

RUN apt-get update \
 && apt-get install -y php7.3 php7.3-dev php7.3-xml

RUN apt-get install -y locales

RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
 && locale-gen

RUN apt-get -y install unixodbc-dev

RUN pecl channel-update pecl.php.net \
 && pecl install sqlsrv \
 && pecl install pdo_sqlsrv \
 && echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini \
 && echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update \
 && ACCEPT_EULA=Y apt-get -y install msodbcsql17

RUN apt-get install libapache2-mod-php7.3 apache2 \
 && rm /var/www/html/index.html \
 && a2dismod mpm_event \
 && a2enmod mpm_prefork \
 && a2enmod php7.3 \
 && echo "extension=pdo_sqlsrv.so" >> /etc/php/7.3/apache2/conf.d/30-pdo_sqlsrv.ini \
 && echo "extension=sqlsrv.so" >> /etc/php/7.3/apache2/conf.d/20-sqlsrv.ini

RUN apt-get install php7.3-mysql \
 #&& echo "extension=pdo_mysql.so" >> /etc/php/7.3/apache2/conf.d/30-pdo_mysql.ini \
 && echo extension=pdo_mysql.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_mysql.ini

RUN apt-get install -y mysql-client

RUN cd /tmp \
 && wget https://github.com/vrana/adminer/releases/download/v4.7.1/adminer-4.7.1-en.php \
 && mv /tmp/adminer-4.7.1-en.php /var/www/html/index.php

COPY start.sh /

CMD ["/start.sh"]

