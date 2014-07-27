#!/bin/bash

# Max brightness value from /sys/class/backlight/*/brightness
MAX=937

# array to store light values for averaging
# TODO: this should be extended such that an arbitrarily-
#       sized array can be generated
LIGHT_ARRAY=(100 100 100 100)

# polling rate in seconds (interval = rate * arraylen)
POLLING_RATE="1"

# Fitted function constants for auto-brightness
M="$(cut -d' ' -f1 ./blsettings.dat)"
B="$(cut -d' ' -f2 ./blsettings.dat)"

# updates the ALS (ambient light sensor) data array
ambient_light() {
    # Raw IR values from 0 (dark) to something really big...
    light=$(cat /sys/bus/iio/devices/iio:device0/in_intensity_ir_raw)
    LIGHT_ARRAY=(${LIGHT_ARRAY[@]:1:3} $light)
}

# calculates the target brightness level (with cutoff)
calc_bright() {
    # Compute average of LIGHT_ARRAY
    # TODO: this is ugly, probably inefficient, and should be improved
    average=$(($((${LIGHT_ARRAY[0]}+${LIGHT_ARRAY[1]}+${LIGHT_ARRAY[2]}+${LIGHT_ARRAY[3]}))/4))
    #echo "AVG: $average"

    # Brightness based on raw values
    rawbright="($M*$average)+$B"

    # Brightness normalized to a percentage
    bright=$(echo "scale=10;($rawbright)/$MAX*100" | bc)
}

# adjusts brightness
adj_bright() {
    #echo "BRIGHT: $bright"
    xbacklight -set $bright
}

renice 19 -p $$ >/dev/null 2>&1

# adjustment loop
while [ 1 ]; do
    # loop fully updates LIGHT_ARRAY
    # could poll and update every time instead...
    for i in {1..4}; do
        ambient_light
        sleep $POLLING_RATE
    done
    calc_bright
    adj_bright
done
