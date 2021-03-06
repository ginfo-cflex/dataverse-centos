#!/bin/bash
DIR=$PWD
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
echo "${GREEN}Stopping Sendmail!${RESET}"
sudo systemctl stop sendmail
echo "${GREEN}Backing up old installation!${RESET}"
TIMESTAMP=$(date "+%Y.%m.%d-%H.%M.%S")
/bin/cp -R /etc/mail $DIR/backup/mail-$TIMESTAMP
echo "${GREEN}Removing old settings!${RESET}"
yum remove -y sendmail sendmail-c4
echo "${GREEN}Installing dependencies!${RESET}"
yum install -y sendmail sendmail-cf m4 ntp
# SETTING NTP
echo "${GREEN}Setting up ntpd!${RESET}"
sudo systemctl stop ntpd
mv /etc/ntp.conf /etc/ntp.conf.bkp
/bin/cp -f $DIR/conf/ntp.conf /etc/ntp.conf
sudo systemctl start ntpd
sleep 2
# SETTING SENDMAIL
echo "${GREEN}Setting up Sendmail!${RESET}"
hostname >/etc/mail/local-host-names
hostname >/etc/mail/relay-domains
mv /etc/mail/sendmail.mc /etc/mail/sendmail.mc.bkp
HOST=$(hostname --fqdn)
sed "s/dataverse.c3.furg.br/$HOST/g" $DIR/mail/sendmail.config >$DIR/mail/sendmail.mc
/bin/cp -f $DIR/mail/sendmail.mc /etc/mail/sendmail.mc
m4 /etc/mail/sendmail.mc >/etc/mail/sendmail.cf
echo "ADMIN_EMAIL	root@$HOST" >>$DIR/default.config
echo "MAIL_SERVER	127.0.0.1" >>$DIR/default.config
# SENDMAIL SYSTEM START
echo "${GREEN}Enabling Sendmail to start with the system!${RESET}"
sudo systemctl enable sendmail
echo "${GREEN}Starting Sendmail!${RESET}"
sudo systemctl start sendmail
sleep 2
# SENDMAIL EMAIL TEST
echo "${GREEN}Email test on Sendmail!${RESET}"
echo "To: dataverse@furg.br" >$DIR/mail/mail.txt
echo "Subject: [Dataverse Script] Sendmail Test">>$DIR/mail/mail.txt
echo "From: $USER@$HOST" >>$DIR/mail/mail.txt
echo " " >>$DIR/mail/mail.txt
echo "Server:" >>$DIR/mail/mail.txt
echo $HOST >>$DIR/mail/mail.txt
echo "Time:" >>$DIR/mail/mail.txt
TIME=$(date)
echo $TIME >>$DIR/mail/mail.txt
sendmail -vt <$DIR/mail/mail.txt
# SERVICE SENDMAIL STATUS
echo "${GREEN}Sendmail status!${RESET}"
sudo systemctl status sendmail
echo " "
echo "${GREEN}Sendmail installed!${RESET}"
echo "Stage (1/11) done!"
echo "${RED}Ctrl+C${RESET} to stop or ${GREEN}Enter${RESET} to continue!"
# read -e $X