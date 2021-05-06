注意：批处理命令对空格敏感，不能多空格或少空格

### 系统参数

~~~shell
%SystemRoot%   ===    C:\WINDOWS    (%windir% 同样)

%ProgramFiles% ===    C:\Program Files

%USERPROFILE%  ===    C:\Documents and Settings\Administrator  (子目录有“桌面”,“开始菜单”,“收藏夹”等)

%APPDATA%      ===    C:\Documents and Settings\Administrator\Application Data

%TEMP%         ===    C:\DOCUME~1\ADMINI~1\LOCALS~1\Temp  (%TEM% 同样)

%APPDATA%      ===    C:\Documents and Settings\Administrator\Application Data

%OS%           ===    Windows_NT (系统)

%Path%         ===    %SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem  (原本的设置)

%HOMEDRIVE%    ===    C:   (系统盘)

%HOMEPATH%     ===    \Documents and Settings\Administrator
~~~

### 命令行调用批处理文件时使用的参数

%[1-9]表示参数，参数是指在运行批处理文件时在文件名后加的以空格(或者Tab)分隔的字符串。

变量可以从%0到%9，%0表示批处理命令本身，其它参数字符串用 %1 到 %9 顺序表示。

~~~sh
call test2.bat "hello" "haha" #(执行同目录下的“test2.bat”文件，并输入两个参数)
~~~

“test2.bat”文件内容:

~~~sh
echo %1  (打印: "hello")

echo %2  (打印: "haha")

echo %0  (打印: test2.bat)

echo %19 (打印: "hello"9)
~~~

### 常用的简单命令

~~~sh
rem		#注释当前行以后语句

cls		#清屏

exit	#退出

@echo off	#关闭回显，@用于隐藏@后的命令。即，关闭回显，且不显示当前行命令

goto	#搭配标签使用，跳转到标签位置。标签格式：:mark

pause	#暂停

call="%cd%\test2.bat" haha	#调用test2.bat，且传参haha给他

if "%1" == "a" format a:	#判断

if [not] exist [路径\]文件名	#判断文件是否存在

if errorlevel number ()	#判断程序返回值是否为number

set str1=%str1%%str2%   #合并字符串 str1 和 str2

set a=%a:1=kk%			#替换字符串“1”为“kk”

>	#生成文件并写入内容(如果有这文件则覆盖)
>>	#文件里追加内容

copy C:\test\*.* D:\back  #复制C盘test文件夹的所有文件(不包括文件夹及子文件夹里的东西)到D盘的back文件夹

start	#调用任何程序（start chrome.exe www.baidu.com)

~~~

### For命令

1. 如下命令行会显示当前目录下所有以bat或者txt为扩展名的文件名。

~~~sh
for %%c in (*.bat *.txt) do (echo %%c)
~~~

2. 如下命令行会显示当前目录下所有包含有 e 或者 i 的目录名。

~~~sh
for /D %%a in (*e* *i*) do echo %%a
~~~

3. 如下命令行会显示 E盘test目录 下所有以bat或者txt为扩展名的文件名。

~~~sh
for /R E:\test %%b in (*.txt *.bat) do echo %%b
for /r %%c in (*) do (echo %%c)  #遍历当前目录下所有文件
~~~

4. 如下命令行将产生序列 1 2 3 4 5

~~~sh
for /L %%c in (1,1,5) do echo %%c
~~~

5. 以下两句，显示当前的年月日和时间

~~~sh
For /f "tokens=1-3 delims=-/. " %%j In ('Date /T') do echo %%j年%%k月%%l日
For /f "tokens=1,2 delims=: " %%j In ('TIME /T') do echo %%j时%%k分
~~~

6. 把记事本中的内容每一行前面去掉8个字符

~~~sh
setlocal enabledelayedexpansion

for /f %%i in (zhidian.txt) do (

 set atmp=%%i

 set atmp=!atmp:~8!

if {!atmp!}=={} ( echo.) else echo !atmp!

)

#读取记事本里的内容(使用 delims 是为了把一行显示全,否则会以空格为分隔符)
for /f "delims=" %%a in (zhidian.txt) do echo.%%a
~~~