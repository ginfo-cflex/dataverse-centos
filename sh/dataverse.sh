clear
DIR=$PWD
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)
echo "${GREEN}Removing old settings!${RESET}"
rm -rf /tmp/dvinstall
# DOWNLOAD DATAVERSE
echo "${GREEN}Downloading Dataverse!${RESET}"
FILE="dvinstall.zip"
LOCATION="/tmp/$FILE"
LINK=https://github.com/IQSS/dataverse/releases/download/v4.20/dvinstall.zip
if [ -f "$LOCATION" ]; then
    ls $LOCATION
    if [ "$(md5sum $LOCATION)" == "84ca1867f9dc8f8ce51dd3d055b7b275  $LOCATION" ]; then
        unzip /tmp/$FILE -d /tmp
    else
        rm $LOCATION
        wget $LINK -P /tmp
        unzip /tmp/$FILE -d /tmp
    fi
else
    wget $LINK -P /tmp
    unzip /tmp/$FILE -d /tmp
fi
mv /tmp/dvinstall/default.config /tmp/dvinstall/default.config.bkp
cp $DIR/default.config /tmp/dvinstall/default.config
clear
echo "${GREEN}Dataverse Install Settings:${RESET}"
echo " "
cat /tmp/dvinstall/default.config
echo " "
echo "${RED}Attention!${RESET}"
echo " "
echo "If the next step freeze in 'Updates Done. Retarting...'"
echo " "
echo "Open another terminal and run the command:"
echo "# sudo systemctl restart glassfish"
echo " "
echo "${RED}Ctrl+C${RESET} to stop or ${GREEN}Enter${RESET} to continue!"
read -e $X
# START INSTALLER
cd /tmp/dvinstall/
echo " "
echo "${GREEN}Wait... Deploying.${RESET}"
/bin/cp -rf /usr/local/glassfish4/glassfish/domains/domain1/logs/server.log $DIR/logs/glassfish.log
./install -y -f
/bin/cp -rf /usr/local/glassfish4/glassfish/domains/domain1/logs/server.log $DIR/logs/dataverse.log
# ./install -y -f > $DIR/logs/install.log 2> $DIR/logs/install.err
# FIX "EJB Timer Service" ERROR ON DEPLOY
/usr/local/glassfish4/bin/asadmin stop-domain
rm -rf /usr/local/glassfish4/glassfish/domains/domain1/generated/
rm -rf /usr/local/glassfish4/glassfish/domains/domain1/osgi-cache/felix
sudo -u postgres psql dvndb -c 'delete from "EJB__TIMER__TBL"';
echo "Installer log file $DIR/logs/install.log"
echo "Installer error file $DIR/logs/install.err"
echo "Dataverse deploy log file $DIR/logs/dataverse.log"
# GLASSFISH PERMISSIONS
# chown -R glassfish:glassfish /usr/local/glassfish4
chown -R root:root /usr/local/glassfish4
chown -R glassfish:glassfish /usr/local/glassfish4/glassfish/lib
chown -R glassfish:glassfish /usr/local/glassfish4/glassfish/domains/domain1
# RESTARTING GLASSFISH
echo "${GREEN}Restarting Glassfish!${RESET}"
sudo systemctl restart glassfish
sleep 10
# SERVICE GLASSFISH STATUS
echo "${GREEN}Glassfish status!${RESET}"
sudo systemctl status glassfish
echo " "
echo "${GREEN}Glassfish deployed applications:${RESET}"
/usr/local/glassfish4/bin/asadmin list-applications
echo " "
echo "${GREEN}Dataverse deployed!${RESET}"
echo "Stage (7/11) done!"
echo "${RED}Ctrl+C${RESET} to stop or ${GREEN}Enter${RESET} to continue!"
read -e $X