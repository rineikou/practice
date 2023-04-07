
文件共享
net share 共享名称=文件夹路径 /grant:用户名,权限(Read,Change,Full)
net share Docs=E:\Documents /grant:everyone,FULL
net share
net share 共享名称 /delete
挂载
net use z: \\远程计算机\共享文件夹 密码 /user:用户名


查询剩余空间
fsutil volume diskfree C:


--安装Telnet
dism /Online /Enable-Feature /FeatureName:TelnetClient


修改网络名称
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList