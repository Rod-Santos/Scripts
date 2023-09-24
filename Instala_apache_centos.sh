#!/bin/bash

# Instala Bibliotecas Necessárias
yum update
yum install net-tools unzip Xvfb freetype fontconfig mesa-libGL mesa-libGLU gettext libXtst firefox gcc gcc-c++ apr apr-devel apr-util apr-util-devel pcre-devel openssl-devel libtool autoconf bison flex libc.so.6 rpmlib -y
yum groupinstall "X Window System" -y

# Instala o Apache

yum install -y httpd

# Habilita os módulos SSL, Proxy, e Cache 
a2enmod ssl
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod cache

# Cria o arquivo mod_jk.conf e configura-o
echo "LoadModule jk_module /usr/lib64/httpd/modules/mod_jk.so
JkWorkersFile /etc/httpd/conf.d/workers.properties
JkLogFile /var/log/httpd/mod_jk.log
JkLogLevel info
JkLogStampFormat \"[%a %b %d %H:%M:%S %Y] \"
JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories
JkRequestLogFormat \"%w %V %T\"
JkMount /example/* loadbalancer" > /etc/httpd/conf.d/mod_jk.conf

# Criar o arquivo workers.properties
echo "worker.list=loadbalancer
worker.loadbalancer.type=lb
worker.loadbalancer.balance_workers=worker1,worker2

worker.worker1.type=ajp13
worker.worker1.host=localhost
worker.worker1.port=8009

worker.worker2.type=ajp13
worker.worker2.host=localhost
worker.worker2.port=8109" > /etc/httpd/conf.d/workers.properties

# Limpa Cache Yum
yum clean all

# Reinicia o Apache
systemctl restart httpd