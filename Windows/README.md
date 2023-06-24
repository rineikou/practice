# 常用命令
```bat
::文件共享
net share 共享名称=文件夹路径 /grant:用户名,权限(Read,Change,Full)
net share Docs=E:\Documents /grant:everyone,FULL
net share
net share 共享名称 /delete
::挂载
net use z: \\远程计算机\共享文件夹 密码 /user:用户名

::查询剩余空间
fsutil volume diskfree C:

::--安装Telnet
dism /Online /Enable-Feature /FeatureName:TelnetClient

::允许管理模式的远程桌面接受连接
cscript C:\Windows\System32\Scregedit.wsf /ar 0

::修改文件属性：R只读 A存档 H隐藏 S系统
attrib +h +s 文件

::启用目录的区分大小写属性
fsutil file SetCaseSensitiveInfo C:\gentoo enable
```
# 注册表
```
修改网络名称
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList
```

wsl挂载U盘
mount -t drvfs e: /mnt/e
# batch语法
## 示例
```bat
::关闭命令行的回显，避免显示不必要的信息
@echo off
::使用unicode字符集
1>null chcp 65001
title 标题
::第一个数字为文字颜色，第二个数字为背景颜色
color 8f
::获取管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" || (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
echo 你已经获得管理员权限.

pause
```
