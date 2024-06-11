@echo off
1>null chcp 65001
title 设置环境变量
color 8f
:select
choice /C:yn /N /M:"是否设置环境变量(y/n)"
if %errorlevel%==2 goto end
if %errorlevel%==1 goto next
:end
exit
:next
echo Path
setx Path "%Path%;%%JAVA_HOME%%\bin;%%JAVA_HOME%%\jre\bin;%%MAVEN_HOME%%\bin" /M
echo java8
setx CLASSPATH ".;%%JAVA_HOME%%\lib\dt.jar;%%JAVA_HOME%%\lib\tools.jar" /M
setx JAVA_HOME "C:\Runtime\Java\jdk1.8.0_201" /M
echo maven
setx MAVEN_HOME "C:\Runtime\apache-maven-3.9.1" /M
pause