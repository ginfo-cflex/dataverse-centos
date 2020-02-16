#!/bin/bash
DIR=$PWD
# REMOVE CONFIGURAÇÕES ANTIGAS
yum remove -y sendmail sendmail-cf httpd mod_ssl shibboleth shibboleth-embedded-ds
# ATUALIZA PACOTES
yum update -y
# INSTALA REPOSITORIO EPEL FEDORA NO CENTOS 7
yum install -y epel-release
# ATUALIZA PACOTES
yum update -y
yum makecache fast
# INSTALA PACOTES OBRIGATORIOS E RECOMENDADOS
yum install -y nano htop wget git net-tools lynx unzip curl java-1.8.0-openjdk java-1.8.0-openjdk-devel ImageMagick sendmail sendmail-cf m4 R R-core R-core-devel jq python36 lsof httpd mod_ssl
# DOWNLOAD DO PACOTE DE INSTALACAO DO DATAVERSE
dvinstall="/tmp/dvinstall.zip"
link=https://github.com/IQSS/dataverse/releases/download/v4.19/dvinstall.zip
cd /tmp/
# REMOVE AS PASTAS ANTES DE DESCOMPACTAR
rm -rf /tmp/dvinstall
if [ -f "$dvinstall" ]; then
    ls $dvinstall
    if [ "$(md5sum $dvinstall)" == "de4f375f0c68c404e8adc52092cb8334  /tmp/dvinstall.zip" ]; then
        unzip dvinstall.zip
    else
        rm $dvinstall
        wget $link
        unzip dvinstall.zip
    fi
fi
echo "Etapa (1/9) concluida!"
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
cd $DIR
chmod 744 sendmail.sh
./sendmail.sh
echo "Etapa (2/9) concluida!"
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
cd $DIR
chmod 744 glassfish.sh
./glassfish.sh
echo "Etapa (3/9) concluida!"
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
cd $DIR
chmod 744 solr.sh
./solr.sh
echo "Etapa (4/9) concluida!"
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
cd $DIR
chmod 744 postgresql.sh
./postgresql.sh
echo "Etapa (5/9) concluida!"
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
cd $DIR
chmod 744 rserve.sh
./rserve.sh
echo "Etapa (6/9) concluida!"
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
cd $DIR
chmod 744 counter.sh
./counter.sh
echo "Etapa (7/9) concluida!"
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
cd $DIR
chmod 744 shibboleth.sh
./shibboleth.sh
clear
echo "Etapa (8/9) concluida!"
echo " "
echo "ATENÇÃO!!"
echo " "
echo "Se a próxima etapa trancar em 'Updates Done. Retarting...' por mais de 30 segundos."
echo " "
echo "Abra outro terminal e execute o comando:"
echo "# systemctl restart glassfish"
echo " "
echo "Pressione Ctrl+C para cancelar e Enter para continuar!"
read -e $X
# EXECUTA SCRIPT DE INSTALACAO DO DATAVERSE
#
# SE O SCRIPT TRANCAR EM 'Updates Done. Retarting...'
# ABRA OUTRO TERMINAL E REINICIE O GLASSFISH
# $ systemctl restart glassfish
#
cd /tmp/dvinstall
rm -rf default.config
cp $DIR/default.config .
./install
echo "Etapa (9/9) concluida!"