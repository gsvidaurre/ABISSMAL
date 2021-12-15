#!/bin/bash
##
 # Created by PyCharm
 # Author: nmoltta
 # Project: ParentalCareTracking
 # Date: 12/08/2021
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
python_v=$(which python)

irbb_file="/Modules/IRBB.py"
irbb_command="${python_v} ${location}${irbb_file}"

temp_file="/Modules/Temp.py"
temp_command="${python_v} ${location}${temp_file}"

rfid_file="/Modules/RFID.py"
rfid_command="${python_v} ${location}${rfid_file}"

echo ""
echo -e "${Blue}Project:${NC}     ${Green}PARENTAL CARE TRACKING ${NC}"
echo -e "${Blue}Repository:${NC}  https://github.com/lastralab/parentalcaretracking"
echo -e "${Blue}Date:${NC}        ${Blue}November 2021${NC}"
echo -e "${Blue}Authors:${NC}     ${Cyan}Tania Molina & Grace Smith Vidaurre${NC}"
echo ""

echo -e "${Yellow}Setting permissions...${NC}"
find Modules/ -type f -exec chmod 644 {} \;
chown -R ${user_name} .
echo -e "${Yellow}Cleaning up detached screens...${NC}"
#screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill
echo ""

echo -e "Starting screen name: ${Cyan}irbb${NC}..."
sleep 1s
screen -dmS irbb bash -c "${irbb_command}"
echo -e "Started ${Cyan}irbb${NC}."

echo -e "Starting screen name: ${Cyan}rfid${NC}..."
sleep 1s
screen -dmS rfid bash -c "${rfid_command}"
echo -e "Started ${Cyan}rfid${NC}."

echo -e "Starting screen name: ${Cyan}temp${NC}..."
sleep 1s
screen -dmS temp bash -c "${temp_command}"
echo -e "Started ${Cyan}temp${NC}."

echo ""

# TODO: fix to run in background and continue opening screens for later modules
