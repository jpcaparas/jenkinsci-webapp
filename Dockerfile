FROM jenkinsci/jenkins:lts

LABEL maintainer "jp@jpcaparas.com"

### Set default user ###
ARG user=jenkins

### Set MySQL defaults ###
ARG mysql_root_password=root

### Run as ROOT while we install packages ###
USER root

### Retrieve new lists of packages ###
RUN apt-get -y update

### Allows you to easily manage your distribution and independent software vendor software sources. ###
RUN apt-get install -y software-properties-common

### Change sources where we get packages from ###
RUN echo "deb http://mirrors.linode.com/debian/ jessie main contrib non-free" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.linode.com/debian/ jessie main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb-src http://security.debian.org/ jessie/updates main non-free" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.linode.com/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.linode.com/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list

### Retrieve new lists of packages ###
RUN apt-get update

### Install PHP ###
RUN apt-get install -y php5-fpm php5-cli php5-common php5-curl php5-geoip php5-gd php5-imagick php5-json php5-intl php5-mcrypt php5-mysql php5-sqlite php5-odbc php5-pspell php5-xmlrpc php5-xsl

### Install Composer (PHP package manager) ###
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

### Install node.js ###
RUN apt-get install curl python-software-properties
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install nodejs

### Install MySQL (non-interactive) ###
RUN export DEBIAN_FRONTEND=noninteractive \
    && debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_root_password}" \
    && debconf-set-selections <<< "mysql-server mysql-server/root_password_again ${mysql_root_password}" \ 
    && apt-get -y install mysql-server \
    && service mysql start

USER ${user}

# For main web interface:
EXPOSE 8080

# Will be used by attached slave agents
EXPOSE 50000

