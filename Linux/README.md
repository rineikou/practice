# gentoo

>关于多系统
>- 安装Windows前，bios关闭secure boot，否则会被windows拒绝，无法进入系统
>- 硬盘模式要选择ahci，否则无法识别
>- windows要把硬件时间设置为UTC
>- 网络唤醒需要把acpi电源选项设置为s5或soft off

```shell
#检查是否联网，没有执行dhcpcd
date #新机器要检查时间，如果不对可以启动ntp
#使用cfdisk或fdisk进行分区
cfdisk #efi分区，257M，第二个分区全部
lsblk
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
#挂载
mount /dev/sda2 /mnt/gentoo
mkdir /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot
# gentoo安装
cd /mnt/gentoo
links https://mirrors.ustc.edu.cn #找到stage3并下载
tar -xpvf stage3.tar.xz
echo 'GENTOO_MIRRORS="https://mirrors.ustc.edu.cn/gentoo"
ACCEPT_LICENSE="*"
MAKEOPTS="-j$(nproc)"'>>/mnt/gentoo/etc/portage/make.conf
# mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir -p /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf #再修改成国内的rsync://rsync.mirrors.ustc.edu.cn/gentoo-portage/
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
genfstab -U /mnt/gentoo >> /mnt/gentoo/etc/fstab
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
emerge --sync --quiet
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
makeconfig
make && make modules_install
make install
# 配置
echo gentoo > /etc/hostname
emerge --ask --noreplace net-misc/netifrc
文件 /etc/conf.d/net静态IP定义
config_ens0="192.168.0.2 netmask 255.255.255.0 brd 192.168.0.255"
routes_ens0="default via 192.168.0.1"
要使用DHCP，定义 config_eth0:
文件 /etc/conf.d/netDHCP 配置
config_ens0="dhcp"
cd /etc/init.d
ln -s net.lo net.eth0
rc-update add net.eth0 default
nano /etc/hosts
passwd # whattheFUCK123
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge --ask sys-boot/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GENTOO
vim /etc/default/grub...
grub-mkconfig -o /boot/grub/grub.cfg
exit
umount -R /mnt/gentoo
fuser -mv /mnt/gentoo
fuser -kv /mnt/gentoo
reboot
emerge --sync
emerge -avuDN @world # 更新所有已安装的软件包
etc-update #检查和合并配置文件的变化，或者使用 dispatch-conf 来自动合并配置文件。
emerge --depclean #删除不再需要的依赖软件包，或者使用 emerge -ac 来清理孤立的软件包。
revdep-rebuild #修复可能的动态链接库问题，或者使用 emerge @preserved-rebuild 来重建被保留的软件包。
```
```shell
emerge -av --newuse --deep @world #重新编译所有受make.conf的USE影响的软件包
emerge -pv 
# 常用软件
emerge --ask 
```
```
启用第三方仓库
emerge --ask app-eselect/eselect-repository 安装第三方仓库管理插件
emerge --ask dev-vcs/git 安装git（大部分第三方仓库都是git管理）
eselect repository list 查看[第三方仓库列表](Gentoo Overlays)
eselect repository enable gentoo-zh 启用第三方仓库（开这两个就基本够用了）
emerge --sync 更新所有仓库，可以加 -r <仓库名> 更新指定仓库

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
```
 /etc/security/passwdqc.conf 
config=FILE：加载指定的配置文件，该文件可以定义本手册中描述的任何选项，包括加载另一个配置文件，但不允许循环。
min=N0,N1,N2,N3,N4：设置不同类型的密码/短语的最小允许长度。可以使用 disabled 关键字禁用某种类型的密码，无论其长度如何。每个后续的数字都不能大于前一个数字。N0 用于只包含一个字符类的密码，N1 用于包含两个字符类但不符合短语要求的密码，N2 用于短语，N3 和 N4 用于包含三个和四个字符类的密码。
max=N：设置密码的最大允许长度。这可以用于防止用户设置一些系统服务可能过长的密码。如果 max 设置为 8，那么超过 8 个字符的密码不会被拒绝，但会被截断为 8 个字符进行强度检查，并且会警告用户。这是用于传统的基于 DES 的密码哈希的，它们会在 8 个字符处截断密码。
passphrase=N：设置短语所需的单词数，或者设置为 0 禁用用户选择的短语支持。
match=N：设置判断密码是否与用户名或 GECOS 字段相似所需的公共子串长度。
similar=permit|deny：设置是否允许或拒绝与旧密码相似的新密码。
random=N：设置随机生成的密码/短语的长度或单词数。
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
配置
```sh
cp /etc/X11/xinit/xinitrc ~/.xinitrc
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
tar cJvf archive.tar.xz files_or_dirs #压缩
tar xJvf archive.tar.xz #解压
```
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

yt-dlp -f 'bv+ba' url

用这个设置下最高质量 vp9+opus+mp4 的组合，并写入元数据和封面图。因为绝大多数视频都有 vp9 版本，av1 在老视频上没有，容器选 mp4 是因为 vp9 默认用的 webm 容器不支持插入封面，mp4 串流支持比较广泛，不在意的话 mkv 也行。
```shell
yt-dlp --embed-thumbnail \
--embed-chapters \
--add-metadata \
--merge-output-format mp4 \
-f bv[vcodec^=vp9]+ba[acodec=opus] \
-o youtube_%(title)s_%(channel)s(%(channel_id)s)_%(id)s.%(ext)s \
--proxy <Proxy URL> \
<VideoURL>
```
```shell
# 将最好的音频和视频以mp4格式封装
yt-dlp --embed-thumbnail --embed-chapters --add-metadata --merge-output-format mp4 -f bv+ba <VideoURL>
```
```shell
#查看字体
fc-list :lang=zh
fc-match
```



合并音频和视频：

ffmpeg -i video.mp4 -i audio.wav -c:v copy -c:a aac output.mp4