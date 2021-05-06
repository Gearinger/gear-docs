@echo off
set USER=system
set PASSWORD=admin
set DATABASE=orcl

set datetime=%date:~,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
set bat_path=%~dp0
rem echo %bat_path%
echo 开始备份……
rem echo %USER%/%PASSWORD%@%DATABASE%

rem rman命令不能在中文目录下运行，所以cd到根目录
cd /d c:/
rman nocatalog target / CMDFILE '%bat_path%orabackup.rcv' LOG '%bat_path%oracl_log.log'

echo 备份完成！
exit