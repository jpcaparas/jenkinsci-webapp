FROM jenkinsci/jenkins:lts

LABEL maintainer "jp@jpcaparas.com"

### Build args ###
ARG mysql_root_password=root

### Set user to root. Previously, it was jenkins ###
USER root

### Set commands to be non-interactive ###
ENV DEBIAN_FRONTEND="noninteractive"

### Retrieve new lists of packages and update OS ###
RUN apt-get update -y \
    && apt-get upgrade -y

### Allows you to easily manage your distribution and independent software vendor software sources. ###
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl python-software-properties
RUN apt-get install -y apt-utils

### Change sources where we get packages from ###
RUN echo "deb http://mirrors.linode.com/debian/ jessie main contrib non-free" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.linode.com/debian/ jessie main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb-src http://security.debian.org/ jessie/updates main non-free" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.linode.com/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.linode.com/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list

### Retrieve new lists of packages ###
RUN apt-get update -y

### Install PHP ###
RUN apt-get install -y php5-fpm php5-cli php5-common php5-curl php5-geoip php5-gd \
    php5-imagick php5-json php5-intl php5-mcrypt php5-mysql php5-sqlite php5-odbc \
    php5-pspell php5-xmlrpc php5-xsl

### Install Composer (PHP package manager) ###
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

### Install node.js ###
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install nodejs

### Install MariaDB (a fork of MySQL) (non-interactive) ###
RUN apt-get install -y debconf-utils
RUN ["/bin/bash", "-c", "echo \"mariadb-server-10.0 mysql-server/root_password password ${mysql_root_password}\" | debconf-set-selections"]
RUN ["/bin/bash", "-c", "echo \"mariadb-server-10.0 mysql-server/root_password_again password ${mysql_root_password}\" | debconf-set-selections"]
RUN apt-get install -y mariadb-server-10.0

### Install Supervisor ####
RUN apt-get install -y supervisor
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

### Export port for main web interface ###
EXPOSE 8080

### Expose port for slave agents ###
EXPOSE 50000

### Start Supervisor daemon ###
ENTRYPOINT ["/bin/bash", "-c", "supervisord -n"]
