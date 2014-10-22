#!/bin/bash
FILE=./bl.dat
ALS=$(cat /sys/bus/iio/devices/iio:device0/in_intensity_ir_raw)
BL=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
echo -e "$ALS\t$BL" >> $FILE
