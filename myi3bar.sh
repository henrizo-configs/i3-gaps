#! bin/bash

# DEPENDENCY: icons depends on font awesome
bfof protocol to use
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
    date=$(date "+%a %d/%m/%Y")

    #time info
    time=$(date "+%T")
    
    # audio info
    audioState=$(amixer get Master  | grep -Eo "\[(off|on)\]" | sed -n '1,1 p')
    masterLevel=$(amixer get Master | grep -Eo "[0-9]+%"      | sed -n '1,1 p')
    if [[ $audioState == "[off]" ]]
    then
        audioIcon=""
        audioColor=$bloodyred
    else
        audioIcon=""
        audioColor="#bfbfbf"
    fi
       
    # connection info
    wifiStatus=$(ip link show | grep -Eo "state DOWN")
    if [[ $wifiStatus != "state DOWN" ]]
    then
        connectionIcon=""
        connectionColor="#bfbfbf"
        ssid=" connected"
    else
        connectionIcon=""
        connectionColor=$bloodyred
        ssid="not connected"
    fi                    

    # output blocks
        echo ",[{ \"name\"    :\"msg\"
                ,\"color\"    :\"#bfbfbf\"
                ,\"full_text\":\"  $USER@$hostname\"}

                ,{ \"name\"     :\"connectionInfo\"
                ,\"color\"    :\"$connectionColor\"
                ,\"full_text\":\"$connectionIcon  $ssid\"}
                                        
                ,{ \"name\"   :\"masterLevel \"
                ,\"color\"    :\"$audioColor\"
                ,\"full_text\":\"$audioIcon $masterLevel\"}

                ,{ \"name\"   :\"keyboardInfo \"
                ,\"color\"    :\"#bfbfbf\"
                ,\"full_text\":\"  $keyboardLayout\"}
                
               ,{ \"name\"     :\"date\"
                ,\"color\"    :\"#bfbfbf\"
                ,\"full_text\":\"  $date \"}

               ,{ \"name\"     :\"time\"
                ,\"color\"    :\"#bfbfbf\"
                ,\"full_text\":\"  $time \"}
           ]"
    sleep 1
done
