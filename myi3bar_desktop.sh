#! bin/bash

# DEPENDENCY: icons depends on font awesome and typicons
echo '{ "version": 1 }'
# i3 protocol stuff
echo '['
echo '[]'

# static auxiliary variables
defaultColour="#b39478"
bloodyRed="#db4b4b"

# Output blocks loop
while :;
do
    # updating variables
    # keyboard info
    keyboardLayout=$(setxkbmap -query | grep layout | rev | cut -c 1,2 | rev)

    # date info
    date=$(date "+%a, %d %b %Y")

    #time info
    time=$(date "+%T")

    # audio info
    audioState=$(amixer get Master  | grep -Eo "\[(off|on)\]" | sed -n '1,1 p')
    masterLevel=$(amixer get Master | grep -Eo "[0-9]+%"      | sed -n '1,1 p')
    if [[ $audioState == "[off]" ]]
    then
        audioIcon=""
        audioColour=$bloodyRed
    else
        audioIcon=""
        audioColour=$defaultColour
    fi

    # mpd info
    nowPlaying=$(mpc current | sed -E "s/.*\///g")
    
    mpdStatus=$(mpc status | grep -Eo "(playing|paused)")
    if [[ $mpdStatus == "playing" ]]
    then
        mpdIcon=""
    elif [[ $mpdStatus == "paused" ]]
    then
        mpdIcon=""
    else
        mpdIcon=""
    fi

    # connection info
    ethStatus=$(ip link show | grep -Eo "state DOWN")
    if [[ $ethStatus != "state DOWN" ]]
    then
        connectionIcon=""
        connectionColour=$defaultColour
        connectionStatus=" connected"
    else
        connectionIcon=""
        connectionColour=$bloodyRed
        connectionStatus="not connected"
    fi

    # output blocks
        echo ",[{\"name\"     :\"mpd\"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\"$mpdIcon  $nowPlaying\"}

              , {\"name\"     :\"masterLevel \"
              ,  \"color\"    :\"$audioColour\"
              ,  \"full_text\":\"$audioIcon $masterLevel\"}

              , {\"name\"     :\"connectionInfo\"
              ,  \"color\"    :\"$connectionColour\"
              ,  \"full_text\":\"$connectionIcon  $connectionStatus\"}

              , {\"name\"     :\"keyboardInfo \"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\"  $keyboardLayout\"}

              , {\"name\"     :\"date\"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\"  $date\"}

              , {\"name\"     :\"time\"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\" $time\"}
           ]"
    sleep 1
done
