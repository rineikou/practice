#!/bin/zsh
# 设置系统环境，与登录用户无关
sudo echo \
'# fcitx5
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
'>>/etc/environment

# 设置所有用户的环境
#sudo echo \
#'
#'>>/etc/profile/defaultrc.sh
