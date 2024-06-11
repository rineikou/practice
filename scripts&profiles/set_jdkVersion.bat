@echo off
1>null chcp 65001
title 切换jdk版本
color 8f
::申请管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" || (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

:menu
echo [1]jdk8 [2]jdk17 [0]exit
:begin
choice /C:120 /M:"请选择"
if %errorlevel%==3 goto exit
if %errorlevel%==1 goto jdk8
if %errorlevel%==2 goto jdk17
:exit
exit
:jdk8
setx JAVA_HOME "C:\Runtime\Java\jdk1.8.0_201" /m
goto menu
:jdk17
setx JAVA_HOME "C:\Runtime\Java\jdk-17.0.6" /M
goto menu