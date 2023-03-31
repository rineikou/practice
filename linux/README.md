# arch
>archlinux特点
>1. 滚动式更新
>2. 社区活跃，有aur提供大量软件
>3. 简洁，高定制化
>4. 无需编译

>关于多系统
>- 安装Windows前，bios关闭secure boot，否则会被windows拒绝，无法进入系统
>- 硬盘模式要选择ahci，否则无法识别
>- windows要把硬件时间设置为UTC

系统安装
```	sh
#检查是否联网，没有执行dhcpcd
#更换最快的pacman源
reflector -c China -a 10 --sort rate --save /etc/pacman.d/mirrorlist
#更新时间
#timedatectl set-ntp true #启动ntp
#分区和格式化
fdisk -l
fdisk /dev/sda #创建分区+257M，第二个分区全部 p g n +257M w保存
lsblk
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
#挂载
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
#安装
pacstrap /mnt base base-devel intel-ucode linux linux-firmware #安装基础包，指令集，固件。AMD是amd-code
pacstrap /mnt ntfs-3g #用于识别NTFS硬盘格式
pacstrap /mnt grub efibootmgr #安装引导器
pacstrap /mnt dhcpcd iwd vim bash-completion zsh doas #联网工具，编辑工具
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
genfstab -U /mnt >> /mnt/etc/fstab #自动挂载分区
#切换系统环境
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime #设置时区，一般用上海
systemctl enable systemd-networkd systemd-resolved dhcpcd iwd #网络自启动
vi /etc/pacman.conf #去掉Color注释
hwclock --systohc #把系统时间同步到硬件，etc/adjtime
vi /etc/locale.gen #添加需要的编码，一般用utf8 
locale-gen #生成locale
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf #设置成英文，防止tty乱码
echo 'myhost' > /etc/hostname #主机名
echo '127.0.0.1		localhost
::1				localhost
127.0.1.1		myhost.localdomain	myhost
'>>etc/hosts
passwd #修改root密码
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH #生成引导文件
grub-mkconfig -o /boot/grub/grub.cfg #生成grub配置文件
exit
#添加非root用户
useradd -m -G wheel admin
passwd admin
echo 'permit persist :wheel'>>/etc/doas.conf
chmod 400 /etc/doas.conf
umount -R /mnt #不要忘记卸载!!
reboot #完成基本安装，重启
```
配置
```sh
cp /etc/X11/xinit/xinitrc ~/.xinitrc
vim ~/.xinitrc 
vim ~/.zshrc
vim /etc/environment 
#修改配置
vim config.h
sudo make clean install
#查看显示器
xrandr -q
```
其他工具
```sh
usbutils: 查看系统USB设备
pciutils: 查看系统PCI设备
acpi: 用來查看电池电量的工具
sof-firmware：声卡驱动，如果你的机器比较新，那么你可能需要安裝。
xf86-video-intel: Intel核显的渠道，这里我只安装了核心显卡的驱动，如果你有另外的独立显卡，请参考官方文档中的相关内容
mesa: 用來配合显卡的另一种上层驱动
xf86-input-libinput: 笔记本触摸板的驱动
pacman -S udisk2 udiskie #自动识别u盘
systemctl enable udisk2
pacman -S pacmanfm #图形界面的文件管理器
```
常用操作
>退出dwm    mod+shift+Q  
进入dwm     startx  
打开st      mod+shift+enter  
关闭窗口    mod+shift+C  
打开应用    mod+P
调大字体    ctrl+shift+pageup
# shell
```sh

```
