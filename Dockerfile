FROM ubuntu:trusty
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
	git \
	mcrypt \
	nodejs \
	npm \
	openssl \
        libapache2-mod-php5 \
        php5-mysql \
        php5-gd \
        php5-curl \
        php-pear \
	php5-intl \
	php5-json \
	php-soap \
	php5-mongo \
	php-mail \
	php5-mcrypt \
        php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN /usr/sbin/php5enmod mcrypt
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini


ENV ALLOW_OVERRIDE **False**

COPY security.conf /etc/apache2/conf-available/security.conf

RUN npm install -g less less-plugin-clean-css

RUN php5enmod mcrypt
RUN php5enmod opcache
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod auth_basic
RUN a2enmod authn_file
RUN a2enmod authz_user
RUN a2ensite default-ssl.conf

#COPY php.ini /etc/php5/apache2/php.ini
#COPY php.ini.ucf-dist /etc/php5/apache2/php.ini.ucf-dist

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#app source if needed
RUN mkdir /source

#ADD sample/ /app
ADD sample/ /app

# Add VOLUMEs to allow backup of config and application
VOLUME  ["/app","/etc/apache2/sites-enabled","/source"]

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
