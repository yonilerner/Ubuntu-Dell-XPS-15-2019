#!/bin/bash
export XAUTHORITY=/run/user/1000/gdm/Xauthority 
export DISPLAY=:0.0
DISPLAYNAME=eDP-1

log() {
  echo $@ >> /var/log/foo
}

log $@

OLED_BR=`xrandr --verbose | grep -i brightness | cut -f2 -d ' '`
#CURR=`LC_ALL=C /usr/bin/printf "%.*f" 1 $OLED_BR`
CURR=$OLED_BR
log $OLED_BR
log $CURR

MIN=0.2
MAX=1.5

if [ "$1" == "up" ]; then
    VAL=`echo "scale=1; $CURR+0.07" | bc`
else
    VAL=`echo "scale=1; $CURR-0.07" | bc`
fi
log $VAL

if (( `echo "$VAL < $MIN" | bc -l` )); then
    VAL=$MIN
    log small $VAL $MIN
elif (( `echo "$VAL > $MAX" | bc -l` )); then
    VAL=$MAX
    log big $VAL $MAX
fi
#`xrandr --output $DISPLAYNAME --brightness $VAL` 2>&1 >/dev/null | logger -t oled-brightness
log newval $VAL
sleep .1
`xrandr --output $DISPLAYNAME --brightness $VAL` | logger -t oled-brightness
log xrandr --output $DISPLAYNAME --brightness $VAL
log don


# Set Intel backlight to fake value
# to sync OSD brightness indicator to actual brightness
#INTEL_PANEL="/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/"
#if [ -d "$INTEL_PANEL" ]; then
#    PERCENT=`echo "scale=4; $VAL/$MAX" | bc -l`
#    INTEL_MAX=$(cat "$INTEL_PANEL/max_brightness")
#    INTEL_BRIGHTNESS=`echo "scale=4; $PERCENT*$INTEL_MAX" | bc -l`
#    INTEL_BRIGHTNESS=`LC_ALL=C /usr/bin/printf "%.*f" 0 $INTEL_BRIGHTNESS`
#    log $INTEL_BRIGHTNESS
#    #echo $INTEL_BRIGHTNESS > "$INTEL_PANEL/brightness"
#fi
