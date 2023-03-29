@echo off
1>null chcp 65001
title 内网kms激活助手
color 8f
c:
cls
::将biribiri.live 改为vlmcsd服务的ip地址
::将biribiri.live 改为vlmcsd服务的ip地址
::将biribiri.live 改为vlmcsd服务的ip地址

::申请管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

:start
cls
echo 注意：仅在内网情况下可以激活
echo.
echo 正在检查与激活服务器的连接情况......请耐心等待
ping -n 1 biribiri.live | find "超时"  > NUL &&  goto fail
ping -n 1 biribiri.live | find "目标主机"  > NUL &&  goto fail
ping -n 1 biribiri.live | find "无法访问" >nul && goto fail
ping -n 1 biribiri.live | find "故障" >nul && goto fail
ping -n 1 biribiri.live | find "找不到" >nul && goto fail
echo 成功连接
echo.
:menu
echo 请选择项目:
echo = = = = = = = = = = = = = = = = = = = = = =
echo 【1】安装 Windows10 Pro 密钥 并设置 激活服务器（Win11 Pro通用）
echo 【2】设置 Office LTSC 激活服务器 (office16以上)
echo.
echo 【3】仅设置 Windows 激活服务器
echo.
echo 注意：本工具仅能帮助连接内网的激活认证服务器
echo 【0】检查激活状态
echo = = = = = = = = = = = = = = = = = = = = = =
echo.
:select
set /p a=请输入数字后回车:
If "%a%"=="0" goto check
If "%a%"=="1" goto Windows10key
If "%a%"=="2" goto Office16
If "%a%"=="3" goto kms
echo.&echo 输入无效，请重新输入.
pause >nul
goto select

:Windows10key
cls
echo -------------------------------------------
echo 正在安装 Windows10 Pro 密钥...（Win11通用）
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
echo.
echo 连接激活服务器...
echo 会有几个窗口弹出需要手动确认
slmgr /skms biribiri.live:1688
timeout /nobreak /t 1 >nul
echo 重启激活服务...
slmgr /ato
echo -------------------------------------------
echo.
echo 请查看是否完成
echo.
pause
cls
goto menu

:Office16
cls
echo -------------------------------------------
echo 连接激活服务器...
cd "C:\Program Files\Microsoft Office\Office16"
cscript ospp.vbs /sethst:biribiri.live
timeout /nobreak /t 1 >nul
echo 重启激活服务...
cscript ospp.vbs /act
echo -------------------------------------------
echo.
echo 请查看是否完成
echo.
pause
cls
goto menu

:kms
echo 连接激活服务器...
echo 会有几个窗口弹出需要手动确认
slmgr /skms biribiri.live:1688
timeout /nobreak /t 1 >nul
echo 重启激活服务...
slmgr /ato
echo 命令执行完毕
pause
cls
goto menu

:check
cls
echo office激活查看命令行窗口，系统激活会弹出窗口
echo.
timeout /nobreak /t 1 >nul
cscript "C:\Program Files\Microsoft office\Office16\ospp.vbs" /dstatus
echo.
echo 以上为office激活状态
timeout /nobreak /t 2 >nul
echo.
slmgr.vbs -dli
pause
cls
goto menu

:fail
echo.
echo 无法连接到服务器 QAQ
echo.
pause
exit