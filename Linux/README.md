# 常用
```shell
# 修改dev设备默认权限，开机生效
echo 'KERNEL=="tty7",MODE="0660"'>>/etc/udev/rules.d/tty.rules
# 添加字体
cp 字体.tty /usr/share/fonts
fc-cache-fv
#查看字体
fc-list :lang=zh
fc-match
# 修改tty默认字体
vi /etc/conf.d/consolefont	sun12x22
# 定时执行  /etc/crontab  /etc/cron.daily weekly monthly
vi /etc/crontab
#寻找进程并杀死
#fuser -mv /mnt/gentoo
#fuser -kv /mnt/gentoo
# grub设置引导
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge --ask sys-boot/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GENTOO
vim /etc/default/grub...
grub-mkconfig -o /boot/grub/grub.cfg
# 压缩
tar cJvf archive.tar.xz files_or_dirs #使用xzip(-J)压缩
tar xpvf archive.tar.xz #解压,保留权限
#检查端口
telnet ip port
ssh -v -p port root@ip
curl ip:port	#没有拒绝连接
wget ip:port	#提示已连接
#查看目录占用空间
du -bsh
#查看显示器
xrandr -q
#安装picom
paru -S picom-jonaburg-git
mkdir ~/.config/picom
cp /etc/xdg/picom.conf.example ~/.config/picom/picom.conf
picom --experimental-backends --config ~/.config/picom/picom.conf
vim .config/picom/picom.conf
#设置默认透明效果
wintypes: {
normal = { fade = true; shadow = true; opacity = 0.45 }
```
```sh
usbutils: 查看系统USB设备
pciutils: 查看系统PCI设备
acpi: 用來查看电池电量的工具
sof-firmware：声卡驱动，如果你的机器比较新，那么你可能需要安裝。
xf86-video-intel: Intel核显的渠道，这里我只安装了核心显卡的驱动，如果你有另外的独立显卡，请参考官方文档中的相关内容
mesa: 用來配合显卡的另一种上层驱动
xf86-input-libinput: 笔记本触摸板的驱动
```
常用操作
>退出dwm    mod+shift+Q  
进入dwm     startx  
打开st      mod+shift+enter  
关闭窗口    mod+shift+C  
打开应用    mod+P
调大字体    ctrl+shift+pageup

# debian
```shell
# 允许以root登录
vim /etc/gdm3/daemon.conf #在[security]下添加AllowRoot = true
vim /etc/pam.d/gdm-password #删除auth required pam_succeed_if.so user != root quiet success
reboot #重启完成
#ubuntu换阿里源
vim /etc/apt/sources.list #修改sources.list文件，22.04jammy
#如果提示“由于没有公钥，无法验证下列签名： NO_PUBKEY 3B4FE6ACC0B21F32”
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 3B4FE6ACC0B21F32
sudo apt-get update
#ubuntu设置默认语言
sudo dpkg-reconfigure locales
#网页版音频大多为ACC，需要安装解码器
sudo apt-get install ubuntu-restricted-extras
```
# redhat
```shell
#Red Hat Subscription Manager订阅管理器，一直让register，禁用掉就好
vim /etc/yum/pluginconf.d/subscription-manager.conf #修改enabled=0
#查看yum安装路径
rpm -qa|grep redis
rpm -ql redis-3.2.10-2.el7.x86_64
```
# gentoo
## 安装
```shell
#检查网络，时间
#使用cfdisk或fdisk进行分区
fdisk /dev/sda1 #efi分区，257M，用于存放引导程序和文件，如果已有其他引导，可以不划分
lsblk
mkfs.ext4 /dev/sda2 #mkfs.vfat -F 32 /dev/sda1
#挂载
mount /dev/sda2 /mnt/gentoo
#mkdir /mnt/gentoo/boot
#mount /dev/sda1 /mnt/gentoo/boot
# gentoo安装
cd /mnt/gentoo #保持在该目录
links https://mirrors.ustc.edu.cn/gentoo #找到stage3并下载
tar -xpvf stage3.tar.xz
echo 'GENTOO_MIRRORS="https://mirrors.ustc.edu.cn/gentoo"
# 允许所有license
ACCEPT_LICENSE="*"
# 编译时使用内存而不是硬盘，不知是否默认
PORTAGE_TMPDIR="/tmp"
# 编译使用的线程数
MAKEOPTS="-j$(nproc)"'>>etc/portage/make.conf
mkdir -p etc/portage/repos.conf
cp usr/share/portage/config/repos.conf etc/portage/repos.conf/gentoo.conf #再修改成国内的rsync://rsync.mirrors.ustc.edu.cn/gentoo-portage/
cp --dereference /etc/resolv.conf etc/
mount --types proc /proc proc
mount --rbind /sys sys
mount --rbind /dev dev
mount --bind /run run
genfstab -U /mnt/gentoo >> etc/fstab
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
emerge --sync --quiet #省时间可以用websync
echo "Asia/Shanghai" > /etc/timezone
emerge --config sys-libs/timezone-data
nano -w /etc/locale.gen
locale-gen
locale -a
eselect locale list # eselect locale set <NUMBER> 
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
# 安装distribution内核
emerge --ask sys-kernel/gentoo-kernel-bin
emerge --depclean
# 手动编译内核
emerge --ask sys-kernel/gentoo-sources
cd /usr/src/linux
make menuconfig
make && make modules_install
make install
# 配置
echo gentoo > /etc/hostname
emerge --ask --noreplace net-misc/netifrc
echo 'config_enp4s0="dhcp"
config_wlp3s0="dhcp"
metric_enp4s0="90"
metric_wlp3s0="100"'>/etc/conf.d/net
#静态IP定义
#config_ens0="192.168.0.2 netmask 255.255.255.0 brd 192.168.0.255"
#routes_ens0="default via 192.168.0.1"
cd /etc/init.d
ln -s net.lo net.enp4s0
rc-update add net.enp4s0 default
nano /etc/hosts
nano /etc/security/passwdqc.conf #修改密码强度限制 
passwd 
# 如果没有其他引导，可以用grub设置引导
exit
umount -R /mnt/gentoo
reboot
emerge --sync
emerge -avuDN @world # 更新所有已安装的软件包
etc-update #检查和合并配置文件的变化，或者使用 dispatch-conf 来自动合并配置文件。
emerge --depclean #删除不再需要的依赖软件包，或者使用 emerge -ac 来清理孤立的软件包。
revdep-rebuild #修复可能的动态链接库问题，或者使用 emerge @preserved-rebuild 来重建被保留的软件包。
```
```shell
equery list system
emerge -av --newuse --deep @world #重新编译所有受make.conf的USE影响的软件包
emerge -avuDN @world
emerge -avuDN @system
emerge --depclean
emerge -W 包
emrege --depclean
emerge -pv 

#升级整个系统，world来自/var/lib/portage/world
emerge -upv world
emerge -uUpv #避免覆盖版本更高的软件，upgradeonly，-U
#升级系统软件
emerge -u system

#删除旧内核
eclean-kernel -p -n1
eclena-kernel -n1

# 启用第三方仓库
emerge --ask app-eselect/eselect-repository 安装第三方仓库管理插件
eselect repository list 查看[第三方仓库列表](Gentoo Overlays)
eselect repository enable gentoo-zh 启用第三方仓库（如果有和官方相同的包，以第三方为准）
emerge --sync 更新所有仓库，可以加 -r <仓库名> 更新指定仓库
```
## 内核编译
```
内核配置选项

内核 启用 Gentoo 特有选项
Gentoo Linux --->
  Generic Driver Options --->
    [*] Gentoo Linux support
    [*]   Linux dynamic and persistent device naming (userspace devfs) support
    [*]   Select options required by Portage features
        Support for init systems, system and service managers  --->
          [*] OpenRC, runit and other script based systems and managers

内核 启用 devtmpfs 支持（CONFIG_DEVTMPFS）
Device Drivers --->
  Generic Driver Options --->
    [*] Maintain a devtmpfs filesystem to mount at /dev
    [*]   Automount devtmpfs at /dev, after the kernel mounted the rootfs
内核 启用 SCSI 磁盘支持（CONFIG_SCSI, CONFIG_BLK_DEV_SD）
Device Drivers --->
  SCSI device support  ---> 
    <*> SCSI device support
    <*> SCSI disk support
内核 启用基础 SATA 和 PATA 支持（CONFIG_ATA_ACPI, CONFIG_SATA_PMP, CONFIG_SATA_AHCI, CONFIG_ATA_BMDMA, CONFIG_ATA_SFF, CONFIG_ATA_PIIX）
Device Drivers --->
  <*> Serial ATA and Parallel ATA drivers (libata)  --->
    [*] ATA ACPI Support
    [*] SATA Port Multiplier support
    <*> AHCI SATA support (ahci)
    [*] ATA BMDMA support
    [*] ATA SFF support (for legacy IDE and PATA)
    <*> Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support (ata_piix)
内核 启用 Linux 4.4.x 基础 NVMe 支持（CONFIG_BLK_DEV_NVME）
Device Drivers  --->
  <*> NVM Express block device
内核 启用 Linux 5.x.x 基础 NVMe 支持（CONFIG_DEVTMPFS）
Device Drivers --->
  NVME Support --->
    <*> NVM Express block device
内核 启用文件系统支持（CONFIG_EXT2_FS, CONFIG_EXT3_FS，CONFIG_EXT4_FS，CONFIG_BTRFS_FS，CONFIG_MSDOS_FS，CONFIG_VFAT_FS，CONFIG_PROC_FS，和CONFIG_TMPFS）
File systems --->
  <*> Second extended fs support
  <*> The Extended 3 (ext3) filesystem
  <*> The Extended 4 (ext4) filesystem
  <*> Btrfs filesystem support
  DOS/FAT/NT Filesystems  --->
    <*> MSDOS fs support
    <*> VFAT (Windows-95) fs support
 
  Pseudo Filesystems --->
    [*] /proc file system support
    [*] Tmpfs virtual memory file system support (former shm fs)
内核 激活 SMP 支持（CONFIG_SMP）
Processor type and features  --->
  [*] Symmetric multi-processing support
内核 启用 USB 和人类输入设备支持（CONFIG_HID_GENERIC，CONFIG_USB_HID，CONFIG_USB_SUPPORT，CONFIG_USB_XHCI_HCD，var>CONFIG_USB_EHCI_HCD，CONFIG_USB_OHCI_HCD，(CONFIG_HID_GENERIC，CONFIG_USB_HID，CONFIG_USB_SUPPORT，CONFIG_USB_XHCI_HCD，CONFIG_USB_EHCI_HCD，CONFIG_USB_OHCI_HCD，CONFIG_USB4）
HID support  --->
    -*- HID bus support
    <*>   Generic HID driver
    [*]   Battery level reporting for HID devices
      USB HID support  --->
        <*> USB HID transport layer
  [*] USB support  --->
    <*>     xHCI HCD (USB 3.0) support
    <*>     EHCI HCD (USB 2.0) support
    <*>     OHCI HCD (USB 1.1) support
内核 选择处理器类型和功能
Processor type and features  --->
   [ ] Machine Check / overheating reporting 
   [ ]   Intel MCE Features
   [ ]   AMD MCE Features
   Processor family (AMD-Opteron/Athlon64)  --->
      ( ) Opteron/Athlon64/Hammer/K8
      ( ) Intel P4 / older Netburst based Xeon
      ( ) Core 2/newer Xeon
      ( ) Intel Atom
      ( ) Generic-x86-64
Binary Emulations --->
   [*] IA32 Emulation
内核 启用对GPT的支持
-*- Enable the block layer --->
   Partition Types --->
      [*] Advanced partition selection
      [*] EFI GUID Partition support
内核 启用对UEFI的支持
Processor type and features  --->
    [*] EFI runtime service support 
    [*]   EFI stub support
    [*]     EFI mixed-mode support
 
Device Drivers
    Firmware Drivers  --->
        EFI (Extensible Firmware Interface) Support  --->
            <*> EFI Variable Support via sysfs
    Graphics support  --->
        Frame buffer Devices  --->
            <*> Support for frame buffer devices  --->
                [*]   EFI-based Framebuffer Support
```
## stage3 内容
```
stage3包含了以下几类文件和软件包：
/bin目录，包含了一些基本的二进制程序，例如bash、cat、cp、ls等。
/boot目录，包含了一些引导相关的文件，例如grub.cfg、initramfs等。
/dev目录，包含了一些设备文件，例如console、null、tty等。
/etc目录，包含了一些系统配置文件，例如fstab、make.conf、passwd等。
/lib目录，包含了一些基本的库文件，例如libc.so、ld-linux.so等。
/mnt目录，用于挂载其他文件系统，例如cdrom、usb等。
/proc目录，包含了一些内核和进程相关的信息，例如cpuinfo、meminfo、uptime等。
/root目录，是root用户的主目录。
/sbin目录，包含了一些系统管理程序，例如fdisk、mkfs、mount等。
/sys目录，包含了一些系统和硬件相关的信息，例如block、bus、class等。
/tmp目录，用于存放临时文件。
/usr目录，包含了大部分的用户程序和数据，例如bin、lib、share等子目录。
/var目录，包含了一些变化的数据，例如cache、log、tmp等子目录。

除此之外，stage3还包含了以下几个软件包：
app-admin/sudo，用于提升普通用户的权限。
app-editors/nano，一个简单的文本编辑器。
app-misc/ca-certificates，用于验证SSL证书的根证书集合。
app-portage/gentoolkit，一个Gentoo工具箱，包含了一些有用的命令和脚本。
dev-lang/python-exec，一个Python脚本执行器。
dev-util/pkgconfig，一个用于查询已安装库的元数据的工具。
net-misc/curl，一个用于传输数据的命令行工具。
net-misc/iputils，一个网络工具集合，包含了ping、traceroute等命令。
net-misc/netifrc，一个Gentoo网络配置脚本集合。
sys-apps/baselayout，一个Gentoo基本布局软件包，提供了一些必要的文件和脚本。
sys-apps/coreutils，一个GNU核心工具集合，提供了一些基本的命令和功能。
sys-apps/findutils，一个GNU查找工具集合，提供了find、locate等命令。
sys-apps/grep，一个GNU正则表达式查找工具。
sys-apps/kbd，一个键盘工具集合，提供了loadkeys、setfont等命令。
sys-apps/less, 一个分页查看器。
sys-apps/net-tools, 一个网络工具集合, 提供了ifconfig, route等命令.
sys-apps/openrc, 一个Gentoo init系统和服务管理器.
sys-apps/sed, 一个GNU流编辑器.
sys-apps/shadow, 一个用户和组管理工具集合, 提供了useradd, passwd等命令.
sys-apps/sysvinit, 一个System V风格的init程序.
sys-apps/tar, 一个GNU归档工具.
sys-apps/util-linux, 一个Linux系统工具集合, 提供了blkid, fdisk, mount等命令.
sys-devel/binutils, 一个二进制工具集合, 提供了as, ld, nm等命令.
sys-devel/gcc, GNU编译器集合, 提供了gcc, g++, gfortran等命令.
sys-devel/libtool, 一个用于创建可移植库的工具.
sys-devel/make, GNU make工具

stage3 desktop比最小安装多了以下一些包：
x11-base/xorg-server，X11服务器软件包。
x11-drivers/xf86-video-vesa，通用VESA视频驱动程序。
x11-drivers/xf86-input-evdev，通用输入事件驱动程序。
x11-drivers/xf86-input-mouse，鼠标驱动程序。
x11-drivers/xf86-input-keyboard，键盘驱动程序。
x11-misc/xinitrc，X11启动脚本。
```

# arch
系统安装
```shell
#检查是否联网，没有执行dhcpcd
date #新机器要检查时间，如果不对可以启动ntp，timedatectl set-ntp true
#更换最快的pacman源
reflector -c China -a 10 --sort rate --save /etc/pacman.d/mirrorlist
#使用cfdisk或fdisk进行分区
cfdisk #efi分区，257M，第二个分区全部
lsblk
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
#挂载
mount /dev/sda2 /mnt/arch
mkdir /mnt/arch/boot
mount /dev/sda1 /mnt/arch/boot
# arch安装
pacstrap /mnt base base-devel intel-ucode linux linux-firmware #安装基础包，指令集，固件。AMD是amd-code
pacstrap /mnt ntfs-3g #用于识别windows的NTFS文件系统
pacstrap /mnt grub efibootmgr #安装引导器
pacstrap /mnt dhcpcd iwd vim bash-completion zsh doas w3m #联网工具，编辑工具
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

```shell
#aria2加速下载，安装后再配置
FETCHCOMMAND="/usr/bin/aria2c -d \${DISTDIR} -o \{FILE} --allow-overwrite=true --max-tries=5 --max-file-not-found=2 --max-concurrent-downloads=5 --connect-timeout=5 --timeout=5 --split=5 --min-split-size=2M --lowest-speed-limit=20K --max-connection-per-server=9 --uri-selector=feedback \${URI}"
RESUMECOMMAND="${FETCHCOMMAND}"
ccache加速编译,安装后再配置
FEATURES="ccache -test"
CCACHE_DIR="/var/cache/ccache"'>>/mnt/gentoo/etc/portage/make.conf
```
