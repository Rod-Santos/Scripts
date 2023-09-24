#!/bin/bash

# Atualizar o cache do gerenciador de pacotes
apt-get update

# Instala o PostgreSQL
apt-get install -y postgresql-13

# Defina a senha para o superusuário do banco de dados "postgres"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

# Habilite o PostgreSQL para Startar na inicialização
systemctl enable postgresql