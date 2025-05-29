#!/bin/bash

TenantCode=$1
Region=$2
TenantEnvironment=$3

exec > >(tee /var/log/base_install/launch_config_user_data_log/user-data-configure-hostname.log|logger -t user-data -s 2>/dev/console) 2>&1

echo `date '+%Y-%m-%d %H:%M:%S '` "Set Hostname"

function convertIntvalToBase2() # (Val Base)
{
   val=$1
   base=2
   result=""
   while [ $val -ne 0 ] ; do
        result=$(( $val % $base ))$result #residual is next digit
        val=$(( $val / $base ))
   done
   echo -n $result
}

DecimalToBase32() 
{
number=$1
hexnumbers=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V")
hex=""
while [ $number -gt 0 ]
do
remainder=$(($number%32))
number=$(($number/32))
hex=${hexnumbers[remainder]}${hex}
done

echo $hex

}

Get-IPs()
{

subnets=$1
IFS=' '
D2B=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
for subnet in ${subnets[@]}
do
#Split IP and subnet
IFS='/'
read -ra subnetParts <<< "${subnet}"
IP=${subnetParts[0]}
SubnetBits=${subnetParts[1]}

#Convert IP into Binary
#Split IP into different octets and for each one, figure out the binary with leading zeros and add to the total
IFS='.'
read -ra Octets <<< "${IP}"
#echo ${Octets[@]}
IPInBinary=""
for octet in ${Octets[@]}
do
#convert to binary
#OctetInBinary=${D2B[octet]}
OctetInBinary=$(convertIntvalToBase2 $octet)
#get length of binary string add leading zeros to make octet
OctetInBinary=$(printf %08d $OctetInBinary)
#get length of binary string add leading zeros to make octet
IPInBinary=$IPInBinary$OctetInBinary
done
IFS=' '

#Get network ID by subtracting subnet mask
thirtyTw0=32
HostBits=$(($thirtyTw0-$SubnetBits))
NetworkIDInBinary=${IPInBinary:0:SubnetBits}

#Get host ID and get the first host ID by converting all 1s into 0s
HostIDInBinary=${IPInBinary:SubnetBits:HostBits}
HostIDInBinary=${HostIDInBinary//1/0}

#Work out all the host IDs in that subnet by cycling through $i from 1 up to max $HostIDInBinary (i.e. 1s stringed up to $HostBits)
#Work out max $HostIDInBinary
HostBitsTimes1=$(eval "printf "1"%.0s {1..$HostBits}")
imax=$((2#$HostBitsTimes1 - 1))

declare -a IPs
for ((i=1;i<=$imax;i++))
do
#Convert to decimal and add $i
NextHostIDInDecimal=$(((2#$HostIDInBinary) + $i))
#Convert back to binary
#NextHostIDInBinary=${D2B[NextHostIDInDecimal]}
NextHostIDInBinary=$(convertIntvalToBase2 $NextHostIDInDecimal)

#Add leading zeros
#Number of zeros to add 
NoOfZerosToAdd="%0${#HostIDInBinary}"d
NextHostIDInBinary=$(printf $NoOfZerosToAdd $NextHostIDInBinary)
#Work out next IP
#Add networkID to hostID
NextIPInBinary=$NetworkIDInBinary$NextHostIDInBinary
#Split into octets and separate by . then join
IPValue=""
for ((x=1;x<=4;x++))
do
#Work out start character position
StartCharNumber=$((($x-1)*8))
#Get octet in binary
IPOctetInBinary=${NextIPInBinary:StartCharNumber:8}
#Convert octet into decimal
IPOctetInDecimal=$((2#$IPOctetInBinary))
#Add octet to IP
IPValue+=.$IPOctetInDecimal
done
IPValue=${IPValue:1}
IPs+=($IPValue)
done
IPList=(${IPs[@]})
echo ${IPList[@]}
done
}

startdate=$(date +%s -d '2018-01-01 00:00:00')
enddate=$(date +%s)
random=${RANDOM}${RANDOM}
diffSec=$(($enddate-$startdate))
randomdate=$(( ($random%$diffSec) +$startdate ))
minutesSince20180101=$(( ($randomdate-$startdate) / 60 ))

minutesbase32=$(DecimalToBase32 "$minutesSince20180101")
addZeroes=$((5-${#minutesbase32}))
zeroString=$(printf "%0$addZeroes"d "")
minutesString=$zeroString$minutesbase32

macAddress="`wget -q -O - http://169.254.169.254/latest/meta-data/mac`"
subnets="`wget -q -O - http://169.254.169.254/latest/meta-data/network/interfaces/macs/$macAddress/subnet-ipv4-cidr-block`"


IPAddresses=$(Get-IPs "$subnets")
ListOfIPs=(${IPAddresses[0]})

IP="`wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4`"

for ((i=1;i<${#ListOfIPs[@]};i++))
do
if [ ${ListOfIPs[i]} = $IP ];then
IPIndex=$i
break
fi
done

IPIndexbase32=$(DecimalToBase32 "$IPIndex")

if [ ${#IPIndexbase32} -eq 1 ];then
IPIndexbase32=0$IPIndexbase32
fi

randomString=$minutesString$IPIndexbase32

case $Region in
  us-east-1)
    regionid="A2"
    ;;
  us-west-1)
    regionid="A3"
    ;;
  us-west-2)
    regionid="A1"
    ;;
  eu-west-1)
    regionid="A4"
    ;;
  ca-central-1)
    regionid="A5"
    ;;
  ap-southeast-2)
    regionid="A6"
    ;;
  ap-southeast-1)
    regionid="A7"
    ;;
esac

U="U"
clientCode=${TenantCode:2}
tagHostName=${TenantEnvironment:0:1}$regionid$U$clientCode$randomString
HostName=$tagHostName".aws.cloud.<company-name>"
sudo /usr/bin/hostnamectl set-hostname $HostName
echo `date '+%Y-%m-%d %H:%M:%S '` "Set Hostname Complete"

#Set Hostname Tag on Instance
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`"
echo "Instance ID  " $EC2_INSTANCE_ID
echo "HostName" $tagHostName
aws ec2 create-tags --resources $EC2_INSTANCE_ID --tags Key=HostName,Value=$tagHostName --region $Region