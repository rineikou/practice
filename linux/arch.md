>archlinux特点
>1. 滚动式更新
>2. 社区活跃，有aur提供大量软件
>3. 简洁，高定制化
>4. 无需编译

>关于多系统
>- bios关闭secure boot，否则会被windows拒绝，无法进入系统
>- 硬盘模式要选择ahci，否则会导致识别不到硬盘
>- windows里把ide改为ahci：
msconfig选安全引导，进入bios修改为chci，进入系统msconfig取消安全引导，重启。
>- 修改grub默认启动项:  
/etc/default/grub修改GRUB_DEFAULT=???  
sudo grub-mkconfig -o /boot/grub/grub.cfg
# 安装系统
```	bash
#检查是否联网，没有执行dhcpcd
#更换最快的pacman源
reflector -c China -a 10 --sort rate --save /etc/pacman.d/mirrorlist
#更新时间
#timedatectl set-ntp true #启动ntp
#timedatectl status #查询时间状态
#分区
fdisk -l
fdisk /dev/sda #创建分区+257M，第二个分区全部 p g n +257M w保存
#格式化
lsblk
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
#挂载
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
#安装
pacstrap /mnt base linux linux-firmware #安装基础包，内核，固件
pacstrap /mnt dhcpcd vim #安装自动联网工具，编辑工具
genfstab -U /mnt >> /mnt/etc/fstab #自动挂载分区，-U为UUID，-L为卷标
cat /mnt/etc/fstab #检查，可将其他盘手动写入
#切换系统环境
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #设置时区，一般用上海
systemctl enable systemd-networkd systemd-resolved dhcpcd #网络自启动
vi /etc/pacman.conf #去掉Color注释
hwclock --systohc## 把系统时间同步到硬件
cat /etc/adjtime
vi /etc/locale.gen #去除需要编码的注释，一般用utf8 
locale-gen #生成locale
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf #设置成英文，防止tty乱码
echo 'myhostname' > /etc/hostname #主机名
vim /etc/hosts# 编辑hosts文件，添加以下三行
127.0.0.1		localhost
::1				localhost
127.0.1.1		myhostname.localdomain	myhostname
passwd #修改root密码
#安装引导并部署
pacman -S intel-ucode # 安装微指令，英特尔CPU指令集；AMD是amd-code
pacman -S grub efibootmgr #安装引导器
#pacman -S os-prober #grub用来发现其他操作系统
uname -m #查看架构
vim /etc/default/grub #GRUB_DISABLE_OS_PROBER=false删除注释
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH #生成引导文件
grub-mkconfig -o /boot/grub/grub.cfg #生成grub配置文件
cat /boot/grub/grub.cfg #检查是否包含`initramfs-linux-fallback.img initramfs-linux.img intel-ucode.img vmlinuz-linux`
exit
umount -R /mnt
reboot
#完成基本安装
```
# 系统配置
```sh
#修改源
pacman -S reflector 
reflector -c China -a 10 --sort rate --save /etc/pacman.d/mirrorlist
echo "[archlinuxcn]" >> /etc/pacman.conf
echo "Server = https://mirrors.sustech.edu.cn/archlinuxcn/$arch" >> /etc/pacman.conf
sudo pacman -S archlinuxcn-keyring #用于导入GPG key
#添加非root用户
pacman -S sudo 
useradd -m -G wheel admin
passwd admin
#无线网络
pacman -S iwd
systemctl enable iwd
#字体
pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
#man手册
pacman -S man man-pages-zh_cn

pacman -S feh #查看图片
pacman -S alsa-utils #调节声音
pacman -S neofetch #查询系统信息
pacman -S tree #用树显示文件结构
pacman -S net-tools #包含各种网络工具，例如ifconfig
pacman -S git wget #用于下载
pacman -S base-devel #用于编译
pacman -S ntfs-3g # 识别NTFS硬盘格式
pacman -S fcitx5 #输入法
pacman -S firefox
#常用工具
pacman -S linux-headers
```
# 美化
```sh
#以下命令在普通用户下执行

## 汉化
echo "alias cman='man -M /usr//share/man/zh_CN'" >> ~/.zshrc
echo "export LANG=zh_CN.UTF-8" >> ~/.xinitrc
pacman -S fcitx5 fcitx5-qt fcitx5-gtk fcitx
## 安装aur助手paru
git clone https://aur.archlinux.org/paru.git --depth=1
cd paru
makepkg -si

## shell美化
sudo pacman -S zsh
chsh -s /bin/zsh

##窗口管理器
sudo pacman -S xorg #安装xorg包
sudo pacman -S xorg-xinit #用于启动xorg
git clone git://git.suckless.org/dwm --depth=1
cd dwm
sudo make install
cp /etc/X11/xinit/xinitrc ~/.xinitrc
vim ~/.xinitrc #删除twm及后面的内容
echo "exec dwm" > ~/.xinitrc
echo ""
startx #启动
#修改配置
vim config.h
sudo make clean install
# mod+shift+enter 打开st
# mod+shift+C 关闭st
# mod+P 打开应用
# mod+shift+Q 退出dwm
xrandr -q
##

git clone git://git.suckless.org/st --depth=1
git clone git://git.suckless.org/dmenu --depth=1
#配置

ctrl+shift+pageup 调大字体

安装ohmyzsh(shell美化), paru(aur helper), dwm(窗口管理), st(终端), dmenu(软件启动), slstatus
```
# 其他工具
```sh
texinfo: info帮助文档的包
usbutils: 查看系统USB设备
pciutils: 查看系统PCI设备
acpi: 用來查看电池电量的工具
sof-firmware：声卡驱动，如果你的机器比较新，那么你可能需要安裝。
alsa-ucm-conf: 声卡驱动，如果你的机器比较新，那么你可能需要安裝。
xf86-video-intel: Intel核显的渠道，这里我只安装了核心显卡的驱动，如果你有另外的独立显卡，请参考官方文档中的相关内容
mesa: 用來配合显卡的另一种上层驱动
xf86-input-libinput: 笔记本触摸板的驱动
```
```bash
## 可能需要
pacman -S udisk2 udiskie #自动识别u盘
systemctl enabel udisk2
pacman -S pacmanfm #图形界面的文件管理器

#时间
sudo apt install ntpdate
sudo ntpdate time.windows.com
sudo hwclock --localtime --systohc
```
/etc/profile/*
~/.zshrc
~/.xinitrc

```sh
#input method
fcitx5 &

#resolution
xrandr --output Virtual-1 --mode 1920x1080 --rate 60.00

#wallpaper
feh --bg-fill --randomize /picture/dir/*

#
exex dwm
```