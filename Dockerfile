FROM larueli/php-base-image:7.4

LABEL maintainer="ivann.laruelle@gmail.com"

ARG OSTICKET_VERSION=1.15.4
ENV OSTICKET_VERSION=${OSTICKET_VERSION}

USER 0
ADD https://github.com/osTicket/osTicket/releases/download/v${OSTICKET_VERSION}/osTicket-v${OSTICKET_VERSION}.zip /tmp/osTicket.zip
ADD https://github.com/clonemeagain/attachment_preview/archive/master.zip /tmp/attachment_preview.zip
COPY check_install.sh /docker-entrypoint-init.d/
COPY deploy.sh /docker-entrypoint-init.d/

RUN unzip /tmp/osTicket.zip -d /var/www/ && rm -rf /var/www/html && mv /var/www/upload /var/www/html && \
    unzip /tmp/attachment_preview.zip -d /tmp/ && mv /tmp/attachment_preview-master /var/www/html/include/plugins/attachment_preview && \
    mkdir /tmp/i18n && mkdir /tmp/plugins && chmod -R +x /docker-entrypoint-init.d

COPY osTicket/languages/* /var/www/html/include/i18n/
COPY osTicket/plugins/* /var/www/html/include/plugins/
COPY .htaccess /var/www/html/

RUN cp -r /var/www/html/include/i18n/* /tmp/i18n/ && \
    cp -r /var/www/html/include/plugins/* /tmp/plugins/ && \
    chgrp -R 0 /var/www/html && chmod g+rwx -R /var/www/html && \
    chgrp -R 0 /tmp/i18n && chmod g+rwx -R /tmp/i18n && \
    chgrp -R 0 /tmp/plugins && chmod g+rwx -R /tmp/plugins

USER 15420:0

