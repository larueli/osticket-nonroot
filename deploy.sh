#!/bin/bash
if [ ! $(ls -A /var/www/html/include/i18n) ]; then
    cd /tmp
    cp -rf i18n/* /var/www/html/include/i18n/
fi
if [ ! $(ls -A /var/www/html/include/plugins) ]; then
    cd /tmp
    cp -rf plugins/* /var/www/html/include/plugins/
fi