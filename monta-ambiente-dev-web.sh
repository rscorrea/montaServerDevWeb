#!/bin/bash

<<COMMENT
	Desenvolvido por: Rafael Correa - ra.sa.correa@gmail.com

	Este script é para facilitar o processo de instalação de um servidor web para desenvolvimento no Linux.
	Vou usar como base a distribuição linux Ubuntu 14.04 LTS amd64 que pode ser baixada no link http://www.ubuntu.com/download/desktop/

	Será considerado que suas configurações básicas, como rede e conexão a internet, estão funcionando.
	Para que tudo ocorra como o esperado, os repositórios padrões do Ubuntu devem estar configurados e deve haver uma boa conexão a internet.

	Forma de utilização:
		Baixe este script para sua pasta home. Ex: /home/`printenv LOGNAME`
		De permissão de execução para o script. Ex: chmod 755 ~/monta-ambiente-dev-web.sh
		Execute o script. Ex: ~/monta-ambiente-dev-web.sh
		Em alguns momentos o script precisará ter poderes de root. Para isso, informe sua senha de login quando for solicitado.
		Siga as instruções na tela.
COMMENT

USUARIO=`printenv LOGNAME`

# Vamos atualizar os pacotes existentes
sudo apt-get update && sudo apt-get -qy upgrade
# OK - Tudo atualizado.

# Instalando o OpenJDK (Java) no sistema
sudo apt-get -qy install openjdk-7-jre-lib openjdk-7-jre openjdk-7-jdk

# Instalando os serviços principais
sudo apt-get -qy install apache2 php5 mysql-server phpmyadmin git

<<COMMENT
	Durante a instalção será pedido:

	1 - Senha do root para o MySQL - Digite a senha do seu usuário de login na máquina.
	2 - Escolher o servidor Web. Marque a opção Apache2.
	3 - Configurar o PHPMyAdmin
		1 - Marque OK na primeira caixa.
		2 - Escolha SIM para configurar a base de dados do PHPMyAdmin.
		3 - Digite sua senha de login na máquina. Vai digitar 3x essa senha.

	Pronto. Servidor Web básico funcionando. Acesse do seu navegador - http://localhost
COMMENT

# Instalando bibliotecas necessárias
sudo apt-get -qy install php5-curl php5-imagick php5-intl php5-memcache php-pear php5-dev php5-xdebug mcrypt

# Instalando o Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Instalando o Laravel
composer global require 'laravel/installer=~1.1'
sudo ln -s ~/.composer/vendor/laravel/installer/laravel /usr/local/bin/laravel

# Mudando para o diretório de Downloads
cd ~/Downloads

# Baixando o PHPStorm e instalando
# Será feito o download da versão 9.0 - Caso existe uma versão nova, por favor alterar na linha abaixo.
wget -crnd --progress=bar http://download.jetbrains.com/webide/PhpStorm-9.0.tar.gz
sudo tar -xzf PhpStorm-*.tar.gz -C /opt

# Vamos voltar para sua pasta home.
cd

# Agora vamos melhorar as configurações do Apache
# E vamos criar uma pasta chamada projetos
# Nesta pasta, você pode salvar todos os seus projetos e eles estarão automaticamente online no seu servidor.

# Caso essa pasta já exista, por favor comente a próxima linha.
mkdir projetos

# Agora vamos criar o arquivo de configuração do apache
TEXTO='<VirtualHost projetos:80>\n
\n
\tErrorLog ${APACHE_LOG_DIR}/error.log\n
\tCustomLog ${APACHE_LOG_DIR}/access.log combined\n
\tServerName projetos\n
\tDocumentRoot /home/'$USUARIO'/projetos\n
\n
\t<Directory /home/'$USUARIO'/projetos/>\n
\t\tOptions Indexes FollowSymLinks MultiViews\n
\t\tAllowOverride all\n
\t\tOrder Allow,Deny\n
\t\tAllow from all\n
\t\tRequire all granted\n
\t</Directory>\n
\n
</VirtualHost>'

echo -e $TEXTO | sudo tee /etc/apache2/sites-available/001-projetos.conf &> /dev/null
sudo a2ensite 001-projetos.conf

# Coloca o usuario de execução do Apache dentro do grupo do usuario. Para ter acesso as pastas dentro da HOME
sudo usermod -G $USUARIO www-data

# Altera as configurações do /etc/hosts para entender que http://projetos é local
sed -e "s/127.0.0.1\tlocalhost/127.0.0.1\tlocalhost projetos/" /etc/hosts | sudo tee /etc/hosts &> /dev/null

# Reinicia o serviço do Apache2
sudo service apache2 reload

# Recomendo fortemente a utilização do SmartGit como GUI para o Git. Torna o processo mais simples e intuitivo.
# Para instalar, siga os passos abaixo.
cd ~/Downloads
wget -crnd --progress=bar http://www.syntevo.com/downloads/smartgit/smartgit-6_5_8.deb
sudo dpkg -i smartgit-*.deb

# Esta ultima linha inicia o PHPStorm pela primeira vez.
# Atenção nesta execução pois ele irá criar as pastas necessárias e o icone de lançador.
/opt/PhpStorm*/bin/phpstorm.sh

