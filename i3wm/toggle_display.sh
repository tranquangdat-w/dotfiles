if xrandr | grep -q "HDMI-A-0 connected"; then
	xrandr --output eDP --off --output HDMI-A-0 --mode 1920x1080 & bash ~/.config/i3/change-wallpaper.sh & i3-msg restart
else
	xrandr --output HDMI-A-0 --off --output eDP --auto & bash ~/.config/i3/change-wallpaper.sh & i3-msg restart
fi

bash ~/.config/i3/change-wallpaper.sh

