@echo off
sqlplus /nolog @sql.sql
set /p target=填写输出备份的路径：
setlocal enabledelayedexpansion
set dateString=%date:~,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%

if not exist %target%\%dateString%backup (mkdir %target%\%dateString%backup)

for /f %%i in (filepath.txt) do (
	if exist %%i (
		copy %%i %target%\%dateString%backup /Y
		echo %%i >> %target%\%dateString%backup\log.txt
		)
) 

rem pause