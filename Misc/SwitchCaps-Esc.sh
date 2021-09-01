#!/bin/bash

current=$(dconf read /org/gnome/desktop/input-sources/xkb-options)
swapped="['caps:escape']" # ['caps:swapescape'] #change to swapesc to actually switch capslock and escape 
capslock="['caps:capslock']"
echo "Current status: $current"

if [ "$current" == "$swapped" ]
then
  echo "Making caps and escape WORK NORMALLY"
  dconf write /org/gnome/desktop/input-sources/xkb-options $capslock
elif [ "$current" == "$capslock" ]
then
  echo "Swapping caps and escape"
  dconf write /org/gnome/desktop/input-sources/xkb-options $swapped
else
  echo "Enabling caps escape swap for the first time"
  dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"
fi
