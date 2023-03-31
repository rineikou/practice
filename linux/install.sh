#!/bin/zsh
# 系统配置
pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts-extra #字体
pacman -S man man-pages-zh_cn #man手册
pacman -S feh #查看图片
pacman -S alsa-utils #调节声音
pacman -S neofetch #查询系统信息
pacman -S tree #用树显示文件结构
pacman -S net-tools #包含各种网络工具，例如ifconfig
pacman -S git wget #用于下载
pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-mozc #输入法
pacman -S firefox #浏览器
pacman -S xorg #安装xorg包组
pacman -S xorg-xinit #用于启动xorg

#添加区域源
echo '[archlinuxcn]
Server = https://mirrors.sustech.edu.cn/archlinuxcn/$arch'>>/etc/pacman.conf
pacman -S archlinuxcn-keyring #用于导入GPG key
cd /repo
# aur助手paru, {makepkg -si}
git clone https://aur.archlinux.org/paru.git --depth=1
# shell美化, {ohmyzsh/tools/install.sh}
git clone git@github.com:ohmyzsh/ohmyzsh.git --depth=1
# suckless套件, {make install}, {vim config.h, make clean install}
git clone git://git.suckless.org/dwm --depth=1
git clone git://git.suckless.org/st --depth=1
git clone git://git.suckless.org/dmenu --depth=1
git clone git://git.suckless.org/slstatus --depth=1
