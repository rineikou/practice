#!/bin/zsh
# .zshrc
echo 'export LANG=zh_CN.UTF-8'>>~/.zshrc

# .xinitrc
echo \
'#input method
fcitx5

#resolution
xrandr --output Virtual-1 --mode 1920x1080 --rate 60.00

#wallpaper
feh --bg-fill --randomize /picture/dir/*

#dwm
exec dwm
'>>~/.xinitrc
