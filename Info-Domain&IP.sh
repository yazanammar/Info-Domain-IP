#!/bin/bash

# collors
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

RESET=$(tput sgr0)
# خط ال Loading
echo " "
echo -n " Loading: ["
for i in {1..20}; do
    echo -n "${green}#${RESET}"
    sleep 0.05
done
echo "]${green} %100${RESET}"



echo " "
echo " -------- "
echo "< ${yellow}De3fult${RESET} >"
echo " --------" 
echo "   \\"
echo "    \\"
echo "     \\  .--."
echo "       |o_o |"
echo "       |:_/ |"
echo "      //   \\ \\"
echo "     (|     | )"
echo "    /\'\_  _/\`\\"
echo "    \___)=(___/"

echo " "



echo -e "\r Started successfully"
echo " "
echo "${green} * Welcome to the comprehensive tool for gathering information${RESET}" 
echo "   ${green}about IP addresses, domains, subdomains, etc...${RESET}"
echo " "
echo " "
echo " * Please select from the list below :"
echo " ${yellow} "
echo " [1] ==> [Forward-Lookup. ]"
echo " [2] ==> [Reverse-Lookup. ]"
echo " [3] ==> [Zone-Transfers. ]"
echo " [4] ==> [All...          ]"
echo " [5] ==> [More-Information]"
echo " ${RESET} "
read  -p " Enter The Number:${green} ${RESET}" number
echo " "

#=================================================

if [[ $number == 1 ]]
then
echo -e " You Chose ==> [ ${purple}Forward-Lookup ${RESET}]\n"
read  -p " Enter Target Domain (ex : ${blue}g${RESET}${red}o${RESET}${yellow}o${RESET}${blue}g${RESET}${green}l${RESET}${red}e${RESET}.com): " domain
echo -e "\n What Tool Do You Want To Search With ??\n "
echo " [1] ==> [Host]"
echo " [2] ==> [Dig]"
echo " [3] ==> [nslookup]"
echo " [4] ==> [Brute-Force On Subdomains]"
echo " "
read  -p " Enter The Number: " num1
echo " "
fi
if [[ $num1 == 1 ]]
then
echo -e " You Have Chosen [Host] Tool\n"
    host $domain
fi

if [[ $num1 == 2 ]]
then
echo -e " You Have Chosen [Dig] Tool\n"
    dig $domain
dig AAAA $domain |grep "AAAA"
fi
if [[ $num1 == 3 ]]
then
echo -e " You Have Chosen [nslookup] Tool\n"
    nslookup $domain
fi

if [[ $num1 == 4 ]]
then
echo -e " You Have Chosen [Brute-Force On Subdomains]\n"
read  -p " Please Enter The Password List Path (Without Errors) : " wordlist
echo " "
echo -e " \n${green}Brute force attack is underway...${RESET}\n"
for sub in $(cat $wordlist) ;do host -t A $sub.$domain | grep -v " not found"; done
fi

#===================================================
if [[ $number == 2 ]]
then
echo " You Chose ==> [ ${red}Reverse-Lookup ${RESET}]"
echo " "
read  -p " Enter Target ${blue}IPv4${RESET} \"Or\" ${red}IPv6${RESET} : " reverse
echo -e "\n What Tool Do You Want To Search With ??\n "
echo " [1] ==> [Host]"
echo " [2] ==> [Dig]"
echo " [3] ==> [nslookup]"
echo " [4] ==> [Brute-Force On Subdomains]"
echo " "
read  -p " Enter The Number: " num2
echo " "
fi
if [[ $num2 == 1 ]]
then
echo -e " You Have Chosen [Host] Tool\n"
    host -t PTR $reverse
fi

if [[ $num2 == 2 ]]
then
echo -e " You Have Chosen [Dig] Tool\n"
    dig -x $reverse
    dig -x $reverse
fi
if [[ $num2 == 3 ]]
then
echo -e " You Have Chosen [nslookup] Tool\n"
    nslookup $reverse
fi

if [[ $num2 == 4 ]]
then
echo -e " You Have Chosen [Brute-Force On Subdomains]\n"
echo " ${red}This section is still under development \"not complete yet!!\"${RESET}"

#read  -p " Please Enter The Password List Path (Without Errors) : " wordlist2
#echo " "
#for i in {1..254};do host -t PTR $reverse$i | grep -v "not found" | grep "example" ;done
fi
#====================================================
#===================================================
if [[ $number == 3 ]]
then
echo " You Chose ==> [ ${blue}Zone-Transfers ${RESET}]"
echo " "
read  -p " Enter Target Domain (ex : ${blue}g${RESET}${red}o${RESET}${yellow}o${RESET}${blue}g${RESET}${green}l${RESET}${red}e${RESET}.com): " domain
read  -p " Enter Target name server (ex : ns1.google.com) : " nameserver
echo -e "\n What Tool Do You Want To Search With ??\n "
echo " [1] ==> [Host]"
echo " [2] ==> [Dig]"
echo " [3] ==> [Dnsrecon]"
echo " [4] ==> [Dnsenum]"
echo " [5] ==> [Fierce]"
echo " "
read  -p " Enter The Number: " num3
echo " "
fi
if [[ $num3 == 1 ]]
then
echo -e " You Have Chosen [Host] Tool\n"
    host -l $domain $nameserver
fi

if [[ $num3 == 2 ]]
then
echo -e " You Have Chosen [Dig] Tool\n"
    dig axfr $domain @$nameserver
fi
if [[ $num3 == 3 ]]
then
echo -e " You Have Chosen [Dnsrecon] Tool\n"
    dnsrecon -d $domain -t axfr
fi

if [[ $num3 == 4 ]]
then
echo -e " You Have Chosen [Dnsenum]\n"
    dnsenum --enum $domain
fi

if [[ $num3 == 5 ]]
then
echo -e " You Have Chosen [Fierce] Tool\n"
    fierce --domain $domain
fi
#====================================================
if [[ $number == 4 ]]
then
echo " You Chose ==> [ ${red}All... ${RESET}]"
echo " "
echo "${red} Note: This field is not fully created so you may encounter some errors !!${RESET} "
echo " "
read  -p " Enter Target Domain (ex : ${blue}facebool.com${RESET}): " domain
read  -p " Enter Target IPv4 \"Or\" IPv6 : " reverse
read  -p " Enter Target name server (ex : ns1.google.com) : " nameserver
echo " ================================================== "
host $domain
echo " ================================================== "
nslookup $domain
echo " ================================================== "
host -t PTR $reverse
echo " ================================================== "
nslookup $reverse
echo " ================================================== "
host -l $domain $nameserver
echo " ================================================== "
dig axfr $domain @$nameserver
echo " ================================================== "
dnsrecon -d $domain -t axfr
echo " ================================================== "
fierce --domain $domain
echo " ================================================== "
dnsenum --enum $domain
fi

#===============================================

if [[ $number == 5 ]]
then
echo " You Chose ==> [ ${green}More-Information ${RESET}]"
echo " "
echo " ${yellow}--------------------------${RESET}" 
echo " Tool Maker ${yellow}:==>${RESET} ${cyan}[De3fult]${RESET} "
echo " ${yellow}--------------------------${RESET}"
echo " "
echo " ${purple}* Social Media :${RESET}"
echo " ${purple}================${RESET}"
echo " "
echo " ${green}GitHub${RESET} ==> https://github.com/yazanammar"
echo " ${blue}Telegram${RESET} ==> https://t.me/De3fult"
echo " ${red}TryHackMe${RESET} ==> https://tryhackme.com/r/p/De3fult "
echo " ${cyan}Twitter${RESET} ==> https://x.com/Yazan_o_ammar "
echo " "
echo " The Tool Version : ${green}V1.0${RESET}"
echo " Date of creation : ${green}17/1/2025${RESET}"
fi

if [ $number != 1 ] && [ $number != 2 ] && [ $number != 3 ] && [ $number != 4 ] && [ $number != 5 ]
then
    echo "${red} [Error] What do you do ??! \"You did not choose a number from 1 to 5 !!\"${RESET} "
fi
