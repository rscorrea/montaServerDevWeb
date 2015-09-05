#!/bin/bash

# Atualizando o servidor
sudo apt-get update && sudo apt-get -qy upgrade

# Instalando os principais servicos
sudo apt-get -qy install nginx-full php5-fpm php5-cli php5-mcrypt git mysql-server php5-mysql php5-curl php5-imagick php5-intl php5-memcache php-pear php5-dev php5-xdebug mcrypt
# Ira pedir a senha do root para o MySQL - Fornecer a senha e salva-la
sudo mysql_install_db
sudo mysql_secure_installation
# 1 - Ira pedir a senha do root
# 2 - Perguntar se quer alterar. N~ao vejo sentido, visto que acabou de setar ela. Responder n
# 3 - Pede para remover o acesso Anonimo ao MySQL. Responder Y
# 4 - Pede para bloquear o acesso utilizando a conta root. Responder Y
# 5 - Pede para bloquear o acesso utilizando a conta root. Responder Y
# 6 - Pede para remover o banco de teste e o acesso a ele. Responder Y
# 7 - Pede para dar um reload nas permissoes do MySQL. Responder Y

# Otimizando o servidor nginx
# antes vamos fazer um backup do arquivo original
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
# Agora ja podemos apagar o arquivo
sudo rm -f /etc/nginx/nginx.conf
# Verifica o num de processadores da maquina
NUM_PROC=`grep ^processor /proc/cpuinfo | wc -l`
WORKER_PROCESS=$NUM_PROC * 1024;
sed -e 's/pm.max_children = 5/pm.max_children = 20/' /etc/php5/fpm/pool.d/www.conf | sudo tee /etc/php5/fpm/pool.d/www.conf &> /dev/null
sed -e 's/;log_level = notice/log_level = warning/' /etc/php5/fpm/pool.d/www.conf | sudo tee /etc/php5/fpm/pool.d/www.conf &> /dev/null

TEXTO='\n
emergency_restart_threshold\t10\n
emergency_restart_interval\t1m\n
process_control_timeout\t10s\n'

echo -e $TEXTO | sudo tee -a /etc/php5/fpm/pool.d/www.conf &> /dev/null

TEXTO='user www-data www-data;\n
worker_processes  '$NUM_PROC';\n
pid /run/nginx.pid;\n
\n
error_log /var/log/nginx/error.log error;\n
access_log /var/log/nginx/access.log;\n
\n
events {\n
\tworker_connections  '$WORKER_PROCESS';\n
\tmulti_accept on;\n
}\n
\n
worker_rlimit_nofile 40000;\n
\n
location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {\n
\taccess_log        off;\n
\tlog_not_found     off;\n
\texpires           30d;\n
}\n
\n
http {\n
\tinclude\t/etc/nginx/mime.types;\n
\tdefault_type\tapplication/octet-stream;\n
\n
\tclient_body_timeout\t3m;\n
\tclient_header_buffer_size\t1k;\n
\tclient_body_buffer_size\t16K;\n
\tclient_max_body_size\t8m;\n
\tlarge_client_header_buffers\t4 4k;\n
\tsend_timeout\t3m;\n
\n
\tgzip\ton;\n
\tgzip_comp_level\t2;\n
\tgzip_min_length\t1024;\n
\tgzip_proxied\texpired no-cache no-store private auth;\n
\tgzip_types\ttext/plain application/x-javascript text/xml text/css application/xml;\n
\tgzip_buffers\t4 8k;\n
\tgzip_disable "MSIE [1-6]\.";
\n
\toutput_buffers\t1 32k;\n
\tpostpone_output\t1460;\n
\tsendfile\ton;\n
\ttcp_nopush\ton;\n
\ttcp_nodelay\ton;\n
\tsend_lowat\t12000;\n
\tkeepalive_timeout\t75 20;\n
\ttypes_hash_max_size\t2048;\n
\tserver_tokens\toff;\n
\n
\tinclude /etc/nginx/conf.d/*.conf;\n
\tinclude /etc/nginx/sites-enabled/*;\n
}\n
\n
location ~ .php$ {\n
\t# connect to a unix domain-socket:\n
\tfastcgi_pass   unix:/var/run/php5-fpm.sock;\n
\tfastcgi_index  index.php;\n
\n
\tfastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;\n
\tfastcgi_param   SCRIPT_NAME        $fastcgi_script_name;\n
\n
\tfastcgi_buffer_size 128k;\n
\tfastcgi_buffers 256 16k;\n
\tfastcgi_busy_buffers_size 256k;\n
\tfastcgi_temp_file_write_size 256k;\n
\n
\t# This file is present on Debian systems..\n
\tinclude fastcgi_params;\n
}'

echo -e $TEXTO | sudo tee /etc/nginx/nginx.conf &> /dev/null
#
# # Instalando servidor SSH
# sudo apt-get install -qy openssh-server
# # Fazendo backup do arquivo de configuraçao original
# sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.original
#
# # Configurando o SSH Server
# TEXTO = 'Port 22\n
# PermitRootLogin no\n
# PermitEmptyPasswords no\n
# Protocol 2\n
# \n
# HostKey /etc/ssh/ssh_host_rsa_key\n
# HostKey /etc/ssh/ssh_host_dsa_key\n
# HostKey /etc/ssh/ssh_host_ecdsa_key\n
# HostKey /etc/ssh/ssh_host_ed25519_key\n
# \n
# UsePrivilegeSeparation yes\n
# \n
# KeyRegenerationInterval 3600\n
# ServerKeyBits 1024\n
# \n
# SyslogFacility AUTH\n
# LogLevel INFO\n
# \n
# Banner none\n
# PrintLastLog yes\n
# AllowGroups ssh\n
# LoginGraceTime 120\n
# StrictModes yes\n
# \n
# RSAAuthentication yes\n
# PubkeyAuthentication yes\n
# \n
# IgnoreRHosts yes\n
# RhostsRSAAuthentication no\n
# HostbasedAuthentication no\n
# IgnoreUserKnownHosts no\n
# \n
# ChallengeResponseAuthentication no\n
# X11Forwarding yes\n
# X11DisplayOffset 10\n
# PrintMotd no\n
# TCPKeepAlive yes\n
# AcceptEnv LANG LC_*\n
# \n
# Subsytem sftp /usr/lib/openssh/sftp-server\n
# \n
# UsePAM yes\n'
#
# echo -e $TEXTO | sudo tee /etc/ssh/sshd_config &> /dev/null
#
# # Instalando o Composer
# curl -sS https://getcomposer.org/installer | php
# sudo mv composer.phar /usr/local/bin/composer
#
# composer global require 'laravel/installer=~1.1'
# sudo ln -s ~/.composer/vendor/laravel/installer/laravel /usr/local/bin/laravel
#
#
# # Vamos aumentar a segurança do servidor
#
# # Criando usuario para manutencao - NAO VAMOS USAR O ROOT
# # Nome do usuario = peduser
# sudo useradd -G www-data,sudo,adm,ssh -m peduser
# # Vamos definir uma senha para ele
# sudo passwd peduser
#
# # Inserir algumas configuracoes para firewall e proteçao de ataques
# echo -e '\nnet.ipv4.conf.all.accept_redirects = 0\n' | sudo tee -a /etc/sysctl.conf &> /dev/null
