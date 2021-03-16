FROM larueli/php-base-image:7.4

LABEL maintainer="ivann.laruelle@gmail.com"

USER 0
COPY osTicket/osTicket-v1.15.2.zip /osTicket.zip
COPY check_install.sh /docker-entrypoint-init.d/

RUN unzip /osTicket.zip -d /var/www/ && rm -rf /var/www/html && mv /var/www/upload /var/www/html && \
    cp /var/www/html/include/ost-sampleconfig.php /var/www/html/include/ost-config.php && rm -rf osTicket.zip && \
    chmod +x /docker-entrypoint-init.d/check_install.sh

COPY osTicket/languages/* /var/www/html/include/i18n/
COPY osTicket/plugins/* /var/www/html/include/plugins/

RUN git clone https://github.com/clonemeagain/attachment_preview.git /var/www/html/include/plugins/attachment_preview && \
    chgrp -R 0 /var/www && chmod g+rwx -R /var/www

USER 15420:0

