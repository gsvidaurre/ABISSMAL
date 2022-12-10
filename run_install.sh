#!/bin/bash
##
 # Created by PyCharm
 # Author: nmoltta
 # Project: ParentalCareTracking
 # Date: 01/25/2022
##
RED='\033[0;31m'
NC='\033[0m'
BIGreen='\033[1;92m'
Green='\033[0;92m'
Yellow='\033[0;93m'
Blue='\033[0;94m'
Purple='\033[0;95m'
Cyan='\033[0;96m'

user_name=$(whoami)
location=$(pwd)
host_name=$(hostname)
helper_path="${location}/Modules/helper.py"
rfid_path="${location}/Modules/RFID.py"
cron_path="${location}/cron.sh"
email_setup_path="${location}/Modules/Setup/email_service.py"
email_config_path="${location}/Modules/Setup/ssmtp.conf"
hostname_path="/etc/hostname"
hosts_path="/etc/hosts"
bash_v=$(which bash)
python_v=$(which python)

echo -e "${Green}
  _____   _____ _______ _____
 |  __ \ / ____|__   __/ ____|
 | |__) | |       | | | (___
 |  ___/| |       | |  \___ \ \r
 | |    | |____   | |  ____) |
 |_|     \_____|  |_| |_____/
${NC}"
echo -e "${Green}Parental Care Tracking System${NC}"
echo -e "${Blue}Repository:${NC}  https://github.com/lastralab/parentalcaretracking"
echo -e "${Blue}Authors:${NC}     ${Cyan}Molina-Medrano, T. & Smith-Vidaurre, G.${NC}"
echo ""
echo -e "${Yellow}Setting permissions for ${user_name}...${NC}"
find . -type f -exec chmod 644 {} \;
echo ""
echo -e "${BIGreen}Enter the Box ID${NC} (Example: Box_01)"
echo -e "${Yellow}Press 'Enter' to skip configuration.${NC}"
read -r boxid
if [ -n "$boxid" ]
then
	sed -i "s/^box_id.*/box_id = '${boxid}'/" "${helper_path}"
  echo -e "${Purple}Registered ${boxid}${NC}"
else
	echo -e "${Yellow}Skipped.${NC}"
fi
sleep 1
echo ""

echo -e "${BIGreen}Enter RF tag identifier for female${NC} (Format: '01-10-3F-8F-D1')"
echo -e "${Yellow}Press 'Enter' to skip configuration.${NC}"
read -r fem
if [ -n "$fem" ]
then
	sed -i "s/^female =.*/female = '${fem}'/" "${rfid_path}"
  echo -e "${Purple}Registered Female Tag: ${fem}${NC}"
else
	echo -e "${Yellow}Skipped.${NC}"
fi
sleep 1
echo ""

echo -e "${BIGreen}Enter RF tag identifier for male${NC} (Format: '01-10-3F-8F-D1')"
echo -e "${Yellow}Press 'Enter' to skip configuration.${NC}"
read -r mal
if [ -n "$mal" ]
then
	sed -i "s/^male =.*/male = '${fem}'/" "${rfid_path}"
  echo -e "${Purple}Registered Male Tag: ${fem}${NC}"
else
	echo -e "${Yellow}Skipped.${NC}"
fi
sleep 1
echo ""

echo -e "${Yellow}Insert y/Y to install required packages or press 'Enter' to skip.${NC}"
read -r packs
if [ -n "$packs" ]
then
	echo -e "${Yellow}Installing packages:${NC}"
  apt-get update
  apt-get install fish
  apt-get install build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
  apt-get install python3
  curl -O https://bootstrap.pypa.io/get-pip.py
  python -m ensurepip --upgrade
  python get-pip.py
  python -m pip install --upgrade pip
  apt install python3-pip
  pip3 install wiringpi
  pip3 install rpi-gpio
  pip3 install picamera
  apt install -y vim
  apt-get install ntfs-3g
  apt-get install gparted
  apt-get install screen
  chmod +x Main.sh
  apt install nmap
  apt-get install -y gpac
  echo ""
else
	echo -e "${Yellow}Skipped.${NC}"
fi
echo ""

#echo -e "${BIGreen}Enter the email address to send emails from${NC} (smtp enabled)"
#echo -e "${Yellow}Press 'Enter' to skip configuration.${NC}"
#read -r gmail
#if [ -n "$gmail" ]
#then
#	sed -i "s/^source.*/source = '${gmail}'/" "${email_setup_path}"
#  sed -i "s/^AuthUser.*/AuthUser=${gmail}/" "${email_config_path}"
#  echo -e "${Purple}Registered ${gmail}${NC}"
#else
#	echo -e "${Yellow}Skipped.${NC}"
#fi
#echo ""

#echo -e "${BIGreen}Enter the email password${NC}"
#echo -e "${Yellow}Press 'Enter' to skip configuration.${NC}"
#read -r -s pass
#if [ -n "$pass" ]
#then
#	sed -i "s/^key.*/key = '${pass}'/" "${email_setup_path}"
#  sed -i "s/^AuthPass.*/AuthPass=${pass}/" "${email_config_path}"
#  echo -e "${Purple}Registered password${NC}"
#else
#	echo -e "${Yellow}Skipped.${NC}"
#fi
#echo ""

#echo -e "${BIGreen}Enter email(s) to send error alerts.${NC}"
#echo -e "${RED}Note:${NC} ${Yellow}Each email must be contained in single quotes ' ' as the example:${NC}"
#echo -e "${Cyan}'email1@gmail.com', 'email2@gmail.com'${NC}"
#echo ""
#echo -e "${Yellow}Press 'Enter' to skip configuration.${NC}"
#read -r emails
#if [ -n "$emails" ]
#then
#	sed -i "s/^emails.*/emails = [${emails}]/" "${helper_path}"
#  echo -e "${Purple}Registered emails = [${emails}]${NC}"
#else
#	echo -e "${Yellow}Skipped.${NC}"
#fi
#echo ""

echo -e "${Yellow}Insert 'Y/y' to configure Cron or press 'Enter' to skip.${NC}"
read -r cron
if [ -n "$cron" ]
then
  sed -i -e "\$a0 0  * * *   pi ${bash_v} ${location}/cron.sh >> /home/pi/log/pct_cron.log" "/etc/crontab"
  sed -i "s#^location=.*#location=\"${location}\"#" "${cron_path}"
  sed -i "s#^python_v=.*#python_v=\"${python_v}\"#" "${cron_path}"
  service cron reload
  chmod +x cron.sh
  echo -e "${Purple}Configured Cron Job to run every day at midnight${NC}"
  echo -e "PCT Cron jobs will be logged in ${Cyan}/home/pi/log/pct_cron.log${NC}"
else
	echo -e "${Yellow}Skipped.${NC}"
fi
echo ""
sleep 1
echo -e "${Green}Installation complete${NC}"
sleep 1
echo -e "${RED}Raspberry pi needs to be restarted at this point${NC}"
echo ""
echo -e "${RED}Restarting in 5 seconds...${NC}"
sleep 6
echo ""
reboot
