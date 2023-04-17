@echo off
1>null chcp 65001
echo 查询局域网所有ip
::ping所有ip
for /L %%i IN (1,1,254) DO ping -w 2 -n 1 10.0.0.%%i
arp -a