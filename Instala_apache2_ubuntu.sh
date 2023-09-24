#!/bin/bash

# Instala Apache
apt-get update
apt-get install -y net-tools xvfb freetype2-demos fontconfig libgl1-mesa-glx libgl1-mesa-dev libglu1-mesa libglu1-mesa-dev libxtst6 libxtst-dev

apt-get install -y apache2

# Cria  usuário e grupo "apache" 
groupadd apache
useradd -s /bin/false -g apache -d /var/www apache

# Concede Permissões para usuário e grupo Apache 
chown -R apache:apache /var/www

# Habilita os Módulos SSL, Proxy, e Cache
a2enmod ssl
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod cache
a2enmod proxy_html
a2enmod mod_ssl

mkdir -p /etc/libapache2-mod-jk/


# Cria o arquivo mod_jk.conf e configura-o
echo "LoadModule jk_module /usr/lib/apache2/modules/mod_jk.so
JkWorkersFile /etc/libapache2-mod-jk/workers.properties
JkLogFile /var/log/apache2/mod_jk.log
JkLogLevel info
JkLogStampFormat \"[%a %b %d %H:%M:%S %Y] \"
JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories
JkRequestLogFormat \"%w %V %T\"
JkMount /example/* loadbalancer" > /etc/apache2/mods-available/mod_jk.conf

# Criar o arquivo workers.properties
echo "worker.list=loadbalancer
worker.loadbalancer.type=lb
worker.loadbalancer.balance_workers=worker1,worker2

worker.worker1.type=ajp13
worker.worker1.host=localhost
worker.worker1.port=8009

worker.worker2.type=ajp13
worker.worker2.host=localhost
worker.worker2.port=8109" > /etc/libapache2-mod-jk/workers.properties

chown -R apache:apache /etc/libapache2-mod-jk

# Reinicia o Apache
systemctl restart apache2
