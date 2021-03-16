FROM php:7.4-apache

COPY site.conf /etc/apache2/sites-available/000-default.conf
COPY ports.conf /etc/apache2/ports.conf
COPY osTicket/osTicket-v1.15.2.zip /osTicket.zip

LABEL maintainer="ivann.laruelle@gmail.com"

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    apt-get update && apt-get install -y vim rsync nano git zip unzip && \
    install-php-extensions gd calendar intl oauth imap ldap pdo_mysql mysqli mbstring phar json intl fileinfo zip apcu opcache && \
    apt-get autoremove -y && a2enmod rewrite && \
    unzip /osTicket.zip -d /var/www/ && rm -rf /var/www/html && mv /var/www/upload /var/www/html && \
    cp /var/www/html/include/ost-sampleconfig.php /var/www/html/include/ost-config.php

COPY osTicket/languages/* /var/www/html/include/i18n/
COPY osTicket/plugins/* /var/www/html/include/plugins/
COPY entrypoint.sh /entrypoint.sh

RUN git clone https://github.com/clonemeagain/attachment_preview.git /var/www/html/include/plugins/attachment_preview && \
    chgrp -R 0 /var/www && chmod g+rwx -R /var/www && chmod +x /entrypoint.sh && chgrp -R 0 /etc/apache2 && chmod g+rwx -R /etc/apache2

EXPOSE 8080

WORKDIR /var/www/html

USER 15420:0

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "apache2-foreground" ]

