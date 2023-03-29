archlinux特点

1. 滚动式更新
2. 社区活跃，有aur提供大量软件
3. 简洁，高定制化



```	bash

#检查是否联网，没有执行dhcpcd
#更换最快的pacman源
reflector -c China -a 10 --sort rate --save /etc/pacman.d/mirrorlist
#更新时间
timedatectl set-ntp true## 启动ntp
timedatectl status## 查询时间状态
#分区
fdisk -l
fdisk /dev/sda#创建分区+512M，第二个分区全部 p g n +512M w保存
lsblk
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
#安装
pacstrap /mnt base base-devel linux linux-firmware linux-headers#安装基础包
pacstrap /mnt neovim zsh## 安装命令行编辑工具
pacstrap /mnt bash-completion## 安装命令行补全工具
pacstrap /mnt iwd## 安装无线管理工具
pacstrap /mnt dhcpcd## 安装有线管理工具  
pacstrap /mnt ntfs-3g## 安装NTFS硬盘格式识别工具
genfstab -U /mnt >> /mnt/etc/fstab## 生成自动挂载分区的fstab文件，-U为UUID，-L为卷标
cat /mnt/etc/fstab #检查
#配置
arch-chroot /mnt #切换系统环境
ln -s /usr/bin/nvim /usr/bin/vi
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ## 设置时区，一般使用上海
systemctl enable systemd-networkd systemd-resolved iwd dhcpcd #网络自启动
vi /etc/pacman.conf #去掉Color注释
hwclock --systohc## 设置硬件时间
vi /etc/locale.gen	#去除 zh_CN.UTF-8 UTF-8 , ja_JP.UTF-8 UTF-8 和 en_US.UTF-8 UTF-8 三行文件的注释
locale-gen ## 生成locale
echo 'LANG=en_US.UTF-8' > /etc/locale.conf #重定向输出内容到locale.conf 配置文件中
vi /etc/hostname #创建并编辑主机名文件，在第一行写主机名
vi /etc/hosts# 编辑hosts文件，添加以下三行
127.0.0.1		localhost
::1				localhost
127.0.1.1		hostname.localdomain	hostname   ## hostname 为设置的主机名
passwd #修改root密码
#安装引导并部署
pacman -S intel-ucode # 安装微指令，英特尔CPU指令集；AMD是amd-code
pacman -S grub efibootmgr #安装引导器
pacman -S os-prober #grub用来发现其他操作系统
uname -m #查看架构
vi /etc/default/grub #GRUB_DISABLE_OS_PROBER=false删除注释
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB #部署grub
grub-mkconfig -o /boot/grub/grub.cfg #生成grub配置文件
cat /boot/grub/grub.cfg #是否包含`initramfs-linux-fallback.img initramfs-linux.img intel-ucode.img vmlinuz-linux`
useradd -m -G wheel lyh
passwd lyh
eixt
umount -R /mnt
reboot
```

配置

```bash
pacman -Syu
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts-extra #安装字体
```

```bash
#时间
sudo apt install ntpdate
sudo ntpdate time.windows.com
sudo hwclock --localtime --systohc
```



```zsh
# 南方科技大学 (广东深圳) (ipv4, ipv6, http, https)
Server = https://mirrors.sustech.edu.cn/archlinuxcn/$arch
#添加archlinuxcn源
vi /etc/pacman.d/cnmirrorlist
sudo vi /etc/pacman.conf
[archlinuxcn]
SigLevel = Never
Include = /etc/pacman.d/cnmirrorlist
sudo pacman -Syy
sudo pacman -S archlinuxcn-keyring
```

```zsh
#安装yay，bin版本，无需编译
#所有yay相关的，不用sudo
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```


```
关于双系统
#bios关闭secure boot，否则会被windows拒绝，无法进入系统
#硬盘模式要选择ahci，否则会导致识别不到硬盘
#windows把ide改为ahci：msconfig选安全引导，进入bios修改为chci，进入系统msconfig取消安全引导，重启。
#修改grub默认启动项
sudo vi /etc/default/grub #修改GRUB_DEFAULT=
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

net-tools: 一个包含各种网络工具的库，像 `ifconfig` 或者 `netstat`,官方目前使用`ip address` 命令来获取本机的IP地址，但是我仍然喜欢使用`ifconfg`所以这里我安装上这个包

```bash
man-db
man-pages: 提供man页面内容
man-pages-zh_cn: 提供man中文页面內容，这个包下载下來不能直接用，后面改別名会提到
texinfo: info帮助文档的包


tree: 以树形结构显示目录中各种文件的依附关系

pacman-contrib: pacman包管理器的扩展好像是，我主要用裡面的那个pactree命令

neofetch: 一个显示系统信息的工具
usbutils: 查看系统USB设备
pciutils: 查看系统PCI设备
acpi: 用來查看电池电量的工具
```



man-db: 提供man命令

man-pages: 提供man页面内容

man-pages-zh_cn: 提供man中文页面內容，这个包下载下來不能直接用，后面改別名会提到

texinfo: info帮助文档的包

ntfs-3g: 对NTFS文件系統提供支持

tree: 以树形结构显示目录中各种文件的依附关系

pacman-contrib: pacman包管理器的扩展好像是，我主要用裡面的那个pactree命令

neofetch: 一个显示系统信息的工具

wget: 一个用來下载的工具

git: 这个就不用说了，做程序员的都知道这个

usbutils: 查看系统USB设备

pciutils: 查看系统PCI设备

acpi: 用來查看电池电量的工具

```shell
sudo pacman -S adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

## 这里我把官方推荐的所有带unicode标识的全装上了,这样后续就不太会出现乱码的情况了
yay -S ttf-ubraille ttf-symbola otf-cm-unicode ttf-arphic-ukai ttf-arphic-uming ttf-dejavu gnu-free-fonts ttf-google-fonts-git nerd-fonts-complete ttf-hack ttf-joypixels
```

alsa-utils：声卡驱动

sof-firmware：声卡驱动，如果你的机器比较新，那么你可能需要安裝。

alsa-ucm-conf: 声卡驱动，如果你的机器比较新，那么你可能需要安裝。

xf86-video-intel: Intel核显的渠道，这里我只安装了核心显卡的驱动，如果你有另外的独立显卡，请参考官方文档中的相关内容

mesa: 用來配合显卡的另一种上层驱动

xf86-input-libinput: 笔记本触摸板的驱动



w3m：终端内网页浏览器



```bash
##安装dwm
#安装相x窗口系统相关服务
sudo pacman -S xorg xorg-xinit nitrogen picom（xorg-server xorg-apps)
#克隆源码
git clone https://git.suckless.org/dwm --depth=1
git clone https://git.suckless.org/st --depth=1
git clone https://git.suckless.org/dmenu --depth=1
sudo make clean install#dwm dmenu st依次执行编译
vi ~/.xinitrc#添加exec dwm
startx #启动

###配置
alt+shift+enter 打开st
ctrl+shift+pageup 调大字体
xrandr -q
xrandr --output Virtual-1 --mode 1920x1080 --rate 60.00
```

