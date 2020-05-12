#!/bin/bash
DIR=$PWD
echo "Instalando dependências!"
yum install -y python36
echo "Baixando Counter-Processor!"
# INSTALA DEPENDENCIA COUNTER PROCESSOR
FILE="v0.0.1.tar.gz"
LOCATION="/tmp/$FILE"
LINK=https://github.com/CDLUC3/counter-processor/archive/v0.0.1.tar.gz
rm -rf /tmp/counter-processor-0.0.1
rm -rf /usr/local/counter-processor
if [ -f "$LOCATION" ]; then
    ls $LOCATION
    if [ "$(md5sum $LOCATION)" == "25ffe6a101675ec51439db40172f2424  $LOCATION" ]; then
        tar xvfz $LOCATION -C /tmp
    else
        rm $LOCATION
        wget $LINK -P /tmp
        tar xvfz $LOCATION -C /tmp
    fi
else
    wget $LINK -P /tmp
    tar xvfz $LOCATION -C /tmp
fi
echo "Configurando Counter-Processor!"
cp -R /tmp/counter-processor-0.0.1 /usr/local/counter-processor
# cd /usr/local/counter-processor
cp $DIR/bin/GeoLite2-Country /tmp/GeoLite2-Country.tar.gz
tar xvfz /tmp/GeoLite2-Country.tar.gz -C /tmp
cp /tmp/GeoLite2-Country_*/GeoLite2-Country.mmdb /usr/local/counter-processor/maxmind_geoip
# ADICIONA USUARIO COUNTER
useradd counter
chown -R counter:counter /usr/local/counter-processor
echo "Instalando Counter-Processor!"
# INSTALA PIP3
sudo -S -u counter python3.6 -m ensurepip
# INSTALA DEPENDENCIAS VIA PIP3
sudo -S -u counter pip3 install --user -r /usr/local/counter-processor/requirements.txt