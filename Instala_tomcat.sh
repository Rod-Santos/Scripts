#!/bin/bash

# Instala Depdências
apt-get update
apt-get install -y openjdk-11-jdk-headless

# Cria o usuário e grupo "tomcat"
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat


# Baixa e Extrai o Apache Tomcat 8.5 no diretório /opt - Altere para a versão de sua necessidade
cd /opt
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.84/bin/apache-tomcat-8.5.84.tar.gz
tar -xvzf apache-tomcat-8.5.84.tar.gz

# Renomeia o diretório Tomcat
mv apache-tomcat-8.5.84 tomcat

# Ajusta as permissões para o usuário no diretório tomcat
chgrp -R tomcat /opt/tomcat
chmod -R g+r /opt/tomcat/conf
chmod g+x /opt/tomcat/conf
chown -R tomcat.tomcat tomcat/ /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/

# Cria o Serviço 'tomcat'
echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment='JAVA_OPTS=-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true'

Environment=CATALINA_BASE=/opt/tomcat
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat.service

# Ativa, inicia e Habilita o Serviço tomcat
systemctl daemon-reload
systemctl start tomcat
systemctl stop tomcat
systemctl start tomcat
systemctl enable tomcat