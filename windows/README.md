本仓库用于记录windows系操作系统的shell命令





1、开启共享

    x:\net share XXXX=x:\XXXX\XXX
    x:\net share(命令）共享名=那个盘：\那个文件夹\那个文件夹
    比如：c:\net share myshare=d:\downloads\share
    把d:\下的downloads文件夹里的share共享为myshare

2、设置权限

  设置当前目录及子目录(/r)下所有文件(/f *)的所有者为管理员(/a)
takeown /f * /a /r 

我试用如下：
takeown /f C:\test  /a /r


设置当前目录及子目录下的所有文件(* /t)的权限为对所有人都为最高权限(everyone:f)
icacls * /t /grant:r everyone:f


我使用如下：
icacls C:\test /t /grant:r everyone:r

挂在共享文件夹
pushd \\server\folder
例如：pushd \\10.10.10.10\share

查询剩余空间
fsutil volume diskfree C:




--安装Telnet
dism /Online /Enable-Feature /FeatureName:TelnetClient


修改网络名称
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList