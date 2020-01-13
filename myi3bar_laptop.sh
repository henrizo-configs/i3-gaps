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

    # battery info
    batteryLevel=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -E "percentage: .+" | grep -Eo "[0-9]+%" | rev | cut -c 2- | rev)
    batteryState=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -E "state: .+"      | grep -Eo "charging|discharging")

    # battery block will appear only when battery is connected.
    if [[ $batteryLevel != "" ]]
    then
       if (( $batteryLevel <= 100 ))
       then
           batteryIcon=""
           batteryColour=$defaultColour
       fi

       if (( $batteryLevel <= 75 ))
       then
           batteryIcon=""
           batteryColour=$defaultColour
       fi

       if (( $batteryLevel <= 50 ))
       then
           batteryIcon=""
           batteryColour=$defaultColour
       fi

       if (( $batteryLevel <= 30 ))
       then
           batteryIcon=""
           batteryColour=$bloodyRed
       fi

       if (( $batteryLevel <= 10 ))
       then
           batteryIcon=""
           batteryColour=$bloodyRed
       fi

       batteryBlock=",{ \"name\"     :\"batteryInfo \"
                     ,  \"color\"    :\"$batteryColour\"
                     ,  \"full_text\":\"$batteryIcon  $batteryLevel% $batteryState\"}"

    else
        batteryBlock=""
    fi

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
    mpdStatus=$(mpc status | grep -Eo "(playing|paused)")
    if [[ $mpdStatus == "playing" ]]
    then
        nowPlaying=$(mpc current | sed -E "s/\/.*\///g")
        mpdIcon=""
    elif [[ $mpdStatus == "paused" ]]
    then
        nowPlaying=""
        mpdIcon=""
    else
        mpdIcon=""
    fi

    # connection info
    wifiStatus=$(iw dev wlp2s0b1 link)
    if [[ $wifiStatus != "Not connected." ]]
    then
        wlanIcon=""
        wlanColor=$defaultColour
        ssid=$(iw dev wlp2s0b1 link | grep -Eo "SSID: .+" | cut -c 7-)
    else
        wlanIcon=""
        wlanColor=$bloodyRed
        ssid="not connected"
    fi

    # output blocks
        echo ",[{\"name\"     :\"mpd\"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\"$mpdIcon  $nowPlaying\"}

              , {\"name\"     :\"masterLevel \"
              ,  \"color\"    :\"$audioColour\"
              ,  \"full_text\":\"$audioIcon $masterLevel\"}

              , {\"name\"     :\"wlanInfo\"
              ,  \"color\"    :\"$wlanColor\"
              ,  \"full_text\":\"$wlanIcon  $ssid\"}

              , {\"name\"     :\"keyboardInfo \"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\"  $keyboardLayout\"}

              $batteryBlock

              , {\"name\"     :\"date\"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\"  $date\"}

              , {\"name\"     :\"time\"
              ,  \"color\"    :\"$defaultColour\"
              ,  \"full_text\":\" $time\"}
           ]"
    sleep 1
done
