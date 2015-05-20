# Montando um servidor Web para desenvolvimento

### Servidor web com Apache2 - PHP - MySQL - PHPMyAdmin - Laravel - PHPStorm

***

## Instalação

Para a instalação, siga os passos abaixo. Cada passo é um comando no terminal.

1. wget -crnd https://raw.githubusercontent.com/rscorrea/montaServerDevWeb/master/monta-ambiente-dev-web.sh

2. chmod +x monta-ambiente-dev-web.sh

Tendo o arquivo salvo e com permissões de execução, basta executar o script e esperar. Logo no inicio ele irá pedir a senha do seu usuário. Para executar alguns comandos usando o sudo.

Depois de digitar a senha, é só esperar.

3. ./monta-ambiente-dev-web.sh

### Passo a passo do script

Todo o script está comentado. Assim, em cada comando é possível saber o que será atualizado.

Caso queira que algo não seja executado, basta comentar a linha utilizando \# no inicio da linha.

O script faz o Download do PHPStorm e do Smartgit. Antes de executar o script, verifique se as versões destes programas estão atualziadas com o site dos desenvolvedores.