#!/bin/zsh
# .zshrc
echo \
'alias cman='man -M /usr/share/man/zh_CN'
'>>~/.zshrc

# .xinitrc
echo \
'#set chinese
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

#input method
fcitx5

#resolution
xrandr --output Virtual-1 --mode 1920x1080 --rate 60.00

#wallpaper
feh --bg-fill --randomize /picture/dir/*

#dwm
exec dwm
'>>~/.xinitrc
