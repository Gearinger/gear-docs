@echo off 
:: 以“YYYYMMDDHHmmss”格式取出当前时间。 
rem set filename=%date:~3,4%%date:~8,2%%date:~11,2%%time:~1,2%%time:~3,2%%time:~6,2%
rem echo %date%%time%
set filename=%date:~,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
rem echo filename=%filename%
rem 数据库连接名
set USER=xxxxxx
rem 密码
set PASSWORD=xxxxxx

rem 数据库实例
set DATABASE=orcl
if not exist "%~dp0\backup\data"  mkdir %~dp0\backup\data
if not exist "%~dp0\backup\log"   mkdir %~dp0\backup\log
set DATADIR=%~dp0\backup\data
set LOGDIR=%~dp0\backup\log
rem 在Windows 配置定时任务时需要，否则报错文件找不到(%~dp0为批处理文件的所在目录）
set addr=cd /d %~dp0

exp "'%USER%/%PASSWORD%@%DATABASE% as sysdba'" file=%DATADIR%\data_%filename%.dmp log=%LOGDIR%/log_%filename%.log full=y

