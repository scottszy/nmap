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


range="Port${k}"
PortR="$(eval echo \$${range})"
touch ${IP}.txt
rm ${IP}.txt

echo "Scan started at"
date

echo "Running Ack"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m           ACK         \e[0m  " >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt

nmap -p ${PortR} -oG ${IP}.gnmap -sA ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report"  | tee -a ${IP}.txt

echo "Running FIN"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m          FIN          \e[0m " >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt

nmap -p ${PortR} -oG ${IP}.gnmap -sF ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt




echo "Running NULL"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m         NULL          \e[0m " >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt 

nmap -p ${PortR} -oG ${IP}.gnmap -sN ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt



echo "Running SYN"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m         SYN           \e[0m" >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt 

nmap -p ${PortR} -oG ${IP}.gnmap -sS ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt




echo "Running CONNECT"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m       CONNECT         \e[0m" >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt 

nmap -p ${PortR} -oG ${IP}.gnmap -sT ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt




echo "Running Window"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m        WINDOW         \e[0m " >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt

nmap -p ${PortR} -oG ${IP}.gnmap -sW ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt





echo "Running XMAS"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m         XMAS          \e[0m" >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt 

nmap -p ${PortR} -oG ${IP}.gnmap -sX ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt




echo "Running MAIMON"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m        MAIMON         \e[0m" >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt

nmap -p ${PortR} -oG ${IP}.gnmap -sM ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt





echo "Running UDP"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m          UDP          \e[0m" >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt

nmap -p ${PortR} -oG ${IP}.gnmap -sU ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt





echo "Running Protocol"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m       PROTOCOL        \e[0m" >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt

nmap -sO -oG ${IP}.gnmap ${Vuln} ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt



echo "Running Basic scan"
echo "-----------------------" >> ${IP}.txt
echo "\e[46m  Normal Scan        \e[0m" >> ${IP}.txt
echo "-----------------------" >> ${IP}.txt

nmap -p ${PortR} -oG ${IP}.gnmap ${Vuln} ${Vers} ${IP} | grep -v -e "IP" -e "Not" -e "Host" -e "Starting" -e "All" -e "report" | tee -a ${IP}.txt



echo "Your results should be in ${IP}.txt and ${IP}.gnmap" 
##echo "${IP}"
done
