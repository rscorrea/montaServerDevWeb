#!/bin/sh

# Altera o diretorio para a pasta Downloads
cd ~/Downloads


# Repositorio para o temas e icones
add-apt-repository ppa:noobslab/themes
sudo add-apt-repository ppa:noobslab/icons

apt-get update
apt-get upgrade

# Instala no Ubuntu
apt-get install firefox build-essential firmware-linux curl msttcorefonts ttf-xfree86-nonfree unrar zip p7zip-full

apt-get install openjdk-7-jre-lib openjdk-7-jre openjdk-7-jdk

# Instalação Java Oracle
tar -xzf jre-*-linux-x64.tar.gz -C /opt
mv /opt/jre* /opt/jre_atual
update-alternatives --install /usr/bin/java java /opt/jre_atual/bin/java 1
update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /opt/jre_atual/lib/amd64/libnpjp2.so 1
update-alternatives --set mozilla-javaplugin.so /opt/jre_atual/lib/amd64/libnpjp2.so

# Coisas extras e essenciais
apt-get install flashplugin-nonfree

# http://www.skype.com/go/getskype-linux-beta-ubuntu-64
dpkg -i skype-ubuntu-precise_*_i386.deb

# http://get.code-industry.net/public/master-pdf-editor-3.4.12_i386.deb
dpkg -i master-pdf-editor_*_amd64.deb

# Instalação do VLC
apt-get install browser-plugin-vlc mozilla-plugin-vlc vlc vlc-plugin-*

# Para ficar bonito
apt-get install win-themes win-icons

# mkdir ~/.fonts
# cp *.ttf ~/.fonts
# cd ~/.fonts
# fc-cache

# cb_share_config
# sudo vi /usr/share/themes/elementary/gtk-2.0/gtkrc /* -- Esta linha serve para aumentar a largura do scrollbar e das abas de guia do Calc do LibreOffice
# Alterar gtkscrollbar ::slide-width de 6 para 10 ou 12

# apt-get install xfce4-screenshooter
