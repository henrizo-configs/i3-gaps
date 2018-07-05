#! bin/bash

# DEPENDENCY: icons depends on font awesome

# tells i3bar what version of protocol to use
echo '{ "version": 1 }'
# Protocol things that I do not understand
echo '['
echo '[]'

# static main variables
hostname=$(hostname)

# static auxiliary variables
bloodyred="#ed1f2"

# Output blocks loop
while :;
do
    # updating variables
    # keyboard info
    keyboardLayout=$(setxkbmap -query | grep layout | rev | cut -c 1,2 | rev)
    
    # date info
    date=$(date "+%a %d/%m/%Y %T") 
    
    # audio info
    audioState=$(amixer get Master  | grep -Eo "\[(off|on)\]" | sed -n '1,1 p')
    masterLevel=$(amixer get Master | grep -Eo "[0-9]+%"      | sed -n '1,1 p')
    if [[ $audioState == "[off]" ]]
    then
        audioIcon=""
        audioColor=$bloodyred
    else
        audioIcon=""
        audioColor="#DEDEDE"
    fi
       
    # connection info
    wifiStatus=$(ip link show | grep -Eo "state DOWN")
    if [[ $wifiStatus != "state DOWN" ]]
    then
        connectionIcon=""
        connectionColor="#DEDEDE"
        ssid=" connected"
    else
        connectionIcon=""
        connectionColor=$bloodyred
        ssid="not connected"
    fi                    

    # output blocks
        echo ",[{ \"name\"    :\"msg\"
                ,\"color\"    :\"#DEDEDE\"
                ,\"full_text\":\"  $USER@$hostname\"}

                ,{ \"name\"     :\"connectionInfo\"
                ,\"color\"    :\"$connectionColor\"
                ,\"full_text\":\"$connectionIcon  $ssid\"}
                                        
                ,{ \"name\"   :\"masterLevel \"
                ,\"color\"    :\"$audioColor\"
                ,\"full_text\":\"$audioIcon $masterLevel\"}

                ,{ \"name\"   :\"keyboardInfo \"
                ,\"color\"    :\"#DEDEDE\"
                ,\"full_text\":\"  $keyboardLayout\"}
                
               ,{ \"name\"     :\"date\"
                ,\"color\"    :\"#DEDEDE\"
                ,\"full_text\":\"  $date \"}
           ]"
    sleep 1
done
