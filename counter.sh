#!/bin/bash
# INSTALA DEPENDENCIA COUNTER PROCESSOR
DIR=$PWD
counter="/tmp/v0.0.1.tar.gz"
link=https://github.com/CDLUC3/counter-processor/archive/v0.0.1.tar.gz
cd /tmp/
if [ -f "$counter" ]
then
    ls $counter
    md5sum $counter
else
    wget $link
fi
rm -rf counter-processor-0.0.1 /usr/local/counter-processor-0.0.1
tar xvfz v0.0.1.tar.gz
cp -R counter-processor-0.0.1 /usr/local
cd /usr/local/counter-processor-0.0.1
wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
tar xvfz GeoLite2-Country.tar.gz
cp GeoLite2-Country_*/GeoLite2-Country.mmdb maxmind_geoip
# ADICIONA USUARIO COUNTER
useradd counter
chown -R counter:counter /usr/local/counter-processor-0.0.1
python3.6 -m ensurepip
cd /usr/local/counter-processor-0.0.1
pip3 install -r requirements.txt