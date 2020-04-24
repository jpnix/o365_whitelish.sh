#!/bin/bash
#jmp@linuxmail.org
#2019-02-24

SECURITY_GROUP_587=$1
SECURITY_GROUP_25=$2

declare -a ip_list_587
declare -a ip_list_25

get_ip_587()
{
    #get the tcp 587 ip addresses
    echo "getting the ips of 587"
    IPS=$(cat ./urls-and-ip-address-ranges | grep -i $1 | sed -e 's/<[^>]*>//g' | sed 's/,//g' | sed "s/"$1"//g")
    ip_list_587=($IPS)
}

get_ip_25()
{
    #get the tcp 25 ip addresses
    echo "getting the ips of 25"
    IPS=$(cat ./urls-and-ip-address-ranges | grep -i $1 | sed -e 's/<[^>]*>//g' | sed 's/,//g' | sed "s/"$1"//g")
    ip_list_25=($IPS)
}

add_to_sg_587()
{
    echo "adding the list to security group"
    for i in "${ip_list_587[@]}"
    do
    echo "Adding $i to the security group"
      if [[ "$i" == *":"* ]]
    then
      aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_587 --ip-permissions "IpProtocol=tcp,FromPort=80,ToPort=80,Ipv6Ranges=[{CidrIpv6=$i}]"
    else
       aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_587 --protocol tcp --port 80 --cidr $i
    fi
    done
}

add_to_sg_25()
{
    echo "adding the list to security group"
    for i in "${ip_list_25[@]}"
    do
    echo "Adding $i to the security group"
      if [[ "$i" == *":"* ]]
    then
      aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_25 --ip-permissions "IpProtocol=tcp,FromPort=443,ToPort=443,Ipv6Ranges=[{CidrIpv6=$i}]"
    else
       aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_25 --protocol tcp --port 443 --cidr $i
    fi
    done
}

cleanup()
{
    echo "cleaning up the file"
    rm -f ./urls-and-ip-address-ranges
}

main()
{
   /usr/bin/wget https://docs.microsoft.com/en-us/office365/enterprise/urls-and-ip-address-ranges
   get_ip_587 "outlook.office365.com"
   get_ip_25 "outlook.office365.com"
   add_to_sg_587
   add_to_sg_25
   cleanup
}

main
