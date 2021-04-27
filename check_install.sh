#!/bin/bash
if [ -n "${IS_INSTALLED}" ]
then
    rm -rf /var/www/html/setup
fi

if [ -n "${NEEDS_PATCH_REGISTER}" ]
then
    sed -i 's/!$cfg || !$cfg->isClientRegistrationEnabled()/!$cfg/g' /var/www/html/include/class.auth.php
fi