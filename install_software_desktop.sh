#!/bin/sh

# Testar a internet e verificar se está liberada. Não pode haver bloqueio de conteúdo. Caso haja, alterar o IP.

# Fazer o download do Java e do Skype e salvar na pasta ~/Downloads

locale-gen pt_BR pt_BR.UTF-8
dpkg-reconfigure locales

# Altera o diretorio para a pasta Downloads
cd ~/Downloads

apt-get update
apt-get upgrade

# Instala no Ubuntu
apt-get install curl ttf-mscorefonts-installer fonts-freefont-ttf ttf-xfree86-nonfree unrar zip p7zip-full pdfsam

# Instalação Java Oracle
tar -xzf jre-*-linux-i586.tar.gz -C /opt
mv /opt/jre* /opt/jre_atual
update-alternatives --install /usr/bin/java java /opt/jre_atual/bin/java 1
update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /opt/jre_atual/lib/i386/libnpjp2.so 1
update-alternatives --set mozilla-javaplugin.so /opt/jre_atual/lib/i386/libnpjp2.so

# http://www.skype.com/go/getskype-linux-beta-ubuntu-64
dpkg -i skype-ubuntu-precise*_i386.deb
