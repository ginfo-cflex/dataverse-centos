clear
DIR=$PWD
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
mv /tmp/dvinstall/default.config /tmp/dvinstall/default.config.bkp
cp $DIR/default.config /tmp/dvinstall
clear
cat /tmp/dvinstall/default.config
# INICIA INSTALADOR
/tmp/dvinstall/install
# INICIA COLEÇÃO SOLR
sudo -u solr /usr/local/solr/solr-7.3.1/bin/solr create_core -c collection1 -d server/solr/collection1/conf/