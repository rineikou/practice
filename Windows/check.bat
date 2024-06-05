@echo off
1>null chcp 65001
title 查询本机信息
color 8f
echo 本机信息 >.\systemInfo.txt

echo 查询cpu信息
wmic cpu get Name >>.\systemInfo.txt
::wmic cpu get NumberOfCores >>.\systemInfo.txt
::wmic cpu get NumberOfLogicalProcessors >>.\systemInfo.txt

echo 查询系统信息
systemInfo >>.\systeminfo.txt
echo 完成

echo 查询局域网所有ip
::ping所有ip
for /L %%i IN (1,1,254) DO ping -w 2 -n 1 192.168.1.%%i
arp -a
pause
