wallpaper_folder="$HOME/Pictures/"

random_wallpaper=$(find "$wallpaper_folder" -type f | shuf -n 1)

feh --bg-scale "$random_wallpaper"

