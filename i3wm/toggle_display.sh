if xrandr | grep -q "HDMI-1 connected"; then
	xrandr --output eDP-1 --off --output HDMI-1 --mode 1920x1080 & bash ~/.config/i3/change-wallpaper.sh & i3-msg restart
else
	xrandr --output HDMI-1 --off --output eDP-1 --auto & bash ~/.config/i3/change-wallpaper.sh & i3-msg restart
fi

bash ~/.config/i3/change-wallpaper.sh

