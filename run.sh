#!/bin/bash

chown www-data:www-data /source -R

chown www-data:www-data /app -R


cp -f /php5conf.d/*.ini /etc/php5/apache2/conf.d/

if [ "$ALLOW_OVERRIDE" = "**False**" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    a2enmod rewrite
fi

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
