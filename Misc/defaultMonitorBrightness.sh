#grab external monitor's brightness using xrandr
BRIGHTNESS=`xrandr --verbose | grep -m 2 -i brightness | head -n 1 | cut -f2 -d ' '`

#update brightness by given input
BRIGHTNESS=`awk '{print $1+$2}' <<<"${BRIGHTNESS} $1"`

if [ $BRIGHTNESS = "0" ]; then
	xrandr --output eDP-1 --brightness 0;
elif [ $BRIGHTNESS = "1" ]; then
	xrandr --output eDP-1 --brightness 1;
else
	xrandr --output eDP-1 --brightness $BRIGHTNESS;
fi
