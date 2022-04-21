#!/bin/sh
#Created by Sean
clear
echo "\e[41;5;30m Welcome to Auto Nmap \e[0m"
echo "how many targets are there"
read NumOfTargets


for i in $(seq 1 $NumOfTargets)
do
echo "Enter Target #"$i "and then the port/port range you would like to scan"
echo "Example 127.0.0.1 1-500 or for a whole network 192.168.100.0/24 1-500"
read Target$i Port$i
done
read -r -p "Would you like to scan for Vulns as well? This will increase scan time [y/n])" VulnOption
case "$VulnOption" in
    [yY][eE][sS]|[yY])
        Vuln="--script vuln"
	echo "Added $Vuln to scan"

        ;;
    *)
        Vuln=" "
        ;;
esac

read -r -p "Would you like to scan for Versions as well? This will increase scan time [y/n]" VersOption
case "$VersOption" in
    [yY][eE][sS]|[yY])
        Vers="-sV"
        echo "Added $Vers to scan"

        ;;
    *)
        Vers=" "
        ;;
esac

for k in $(seq 1 $NumOfTargets)
do
target="Target${k}"
IP="$(eval echo \$${target})"


# Remove slash from file name if present
fileName="$(eval echo ${IP} | sed 's/\//_/g')"
# Get timestamp
dateTime=$(date +"%b_%d_%Y_%H_%M_%S")
# Add timestamp to file name
fileName="${fileName}_${dateTime}"


range="Port${k}"
PortR="$(eval echo \$${range})"
#touch ${fileName}.txt
#rm ${fileName}.txt
echo " "
echo "Scan started at"
date
echo " "
echo "Running Ack"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m           ACK         \e[0m  " >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sA ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report"  | tee -a ${fileName}.txt

echo "Running FIN"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m          FIN          \e[0m " >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sF ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt




echo "Running NULL"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m         NULL          \e[0m " >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sN ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt



echo "Running SYN"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m         SYN           \e[0m" >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sS ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt




echo "Running CONNECT"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m       CONNECT         \e[0m" >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sT ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt




echo "Running Window"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m        WINDOW         \e[0m " >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sW ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt





echo "Running XMAS"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m         XMAS          \e[0m" >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sX ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt




echo "Running MAIMON"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m        MAIMON         \e[0m" >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sM ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt





echo "Running UDP"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m          UDP          \e[0m" >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap -sU ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt





echo "Running Protocol"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m       PROTOCOL        \e[0m" >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -sO -oG ${fileName}.gnmap ${Vuln} ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt



echo "Running Basic scan"
echo "-----------------------" >> ${fileName}.txt
echo "\e[46m  Normal Scan        \e[0m" >> ${fileName}.txt
echo "-----------------------" >> ${fileName}.txt

nmap -p ${PortR} -oG ${fileName}.gnmap ${Vuln} ${Vers} ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${fileName}.txt



echo "Your results should be in ${fileName}.txt and ${fileName}.gnmap"
##echo "${fileName}"
done
