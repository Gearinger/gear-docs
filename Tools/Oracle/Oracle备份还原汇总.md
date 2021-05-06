## 一、物理全备份和恢复（冷备份）

### 备份

1.查看所有数据文件

~~~sql
select * from dba_data_files;
~~~

2.查看日志文件

~~~sql
select * from v$logfile;
~~~

3.查看控制文件

~~~sql
select * From v$controlfile;
~~~

3.查看临时文件

~~~sql
--缺少会导致sde数据的要素类丢失属性
select * From v$tempfile;
~~~

- 把上面查出来的数据文件、日志文件、控制文件、临时文件用操作系统的复制命令，粘贴到备份目录下即可

- 拷贝前，登录sqlplus，停止数据库

  ~~~sql
  shutdown immediate
  ~~~

- 拷贝完成之后，启动数据库

  ~~~sql
  startup
  ~~~


备份脚本

~~~sh
# bat文件
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

# sql文件
conn / as sysdba;

spool filepath.txt

select file_name name from dba_data_files 
UNION
select member name from v$logfile 
UNION
select name name From v$controlfile
union
SELECT NAME name FROM v$tempfile;

spool off;

exit;
~~~



### 恢复

- 关闭数据库，进行恢复

  ~~~sql
  shutdown immediate
  ~~~

- 把备份的文件拷贝到原来目录

- 启动

  ~~~SQl
  startup
  ~~~

- 登录验证数据是否存在



## 二、expdp、impdp逻辑备份

### 1、数据备份及还原

完整示例过程

~~~shell
//登录
sqlplus system/密码@orcl

//创建临时目录，用于保存备份（在对应位置手动创建对应目录）
create directory dump_dir as 'E:\temp\dmp';

//查询是否存在以下目录
select * from dba_directories;

//赋于要导出数据表的所属用户权限
grant read,write on directory dump_dir to 用户名;

//退出sqlplus
exit;

//针对用户的数据备份(语句后不用加";")
expdp system/密码@orcl directory=dump_dir dumpfile=文件名.dmp logfile=文件名.log schemas=用户名

//针对用户的数据还原(语句后不能加";")
impdp system/密码@orcl directory=dump_dir dumpfile=dmp文件名 logfile=log文件名 schemas=用户名

//利用sql检查数据完整性
select t.table_name , t.num_rows from user_tables t order by t.num_rows desc;

~~~

---

- 导出备份

~~~
1)导出用户及其对象
expdp system/passwd@orcl schemas=用户 dumpfile=expdp.dmp directory=dump_dir logfile=expdp.log

2)导出指定表
expdp system/passwd@orcl tables=emp,dept dumpfile=expdp.dmp directory=dump_dir logfile=expdp.log

3)按查询条件导
expdp system/passwd@orcl directory=dump_dir dumpfile=expdp.dmp tables=empquery='where deptno=20' logfile=expdp.log

4)按表空间导
expdp system/passwd@orcl directory=dump_dir dumpfile=tablespace.dmp tablespaces=temp,example logfile=expdp.log

5)导整个数据库
expdp system/admin@TEST directory=dump_dir dumpfile=test2.dmp logfile=test.log full=y
~~~

- 导入还原

~~~
1)导入用户（从用户scott导入到用户scott）
impdp system/passwd@orcl directory=dump_dir dumpfile=expdp.dmp schemas=scott logfile=impdp.log

2)导入表（从scott用户中把表dept和emp导入到system用户中）
impdp system/passwd@orcl directory=dump_dir dumpfile=expdp.dmp tables=scott.dept,scott.emp remap_schema=scott:system logfile=impdp.log table_exists_action=replace (表空间已存在则替换)

3)导入表空间
impdp system/passwd@orcl directory=dump_dir dumpfile=tablespace.dmp tablespaces=example logfile=impdp.log

4)导入整个数据库
impdp system/passwd@orcl directory=dump_dir dumpfile=full.dmp full=y logfile=impdp.log
~~~

注意：
oracle10g之后impdp的table_exists_action参数
table_exists_action选项：{skip 是如果已存在表，则跳过并处理下一个对象；append是为表增加数据；truncate是截断表，然后为其增加新数据；replace是删除已存在表，重新建表并追加数据}

### 2、备份脚本

#### 备份脚本

~~~shell
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

set /P tableExp=<%addr:~6%table.txt
echo ================================================   
echo start backup  %tableExp%
echo ================================================
if "%tableExp%"=="" (
goto end
) else (
goto demo2
)
echo (%tableExp%)
 
:demo2
pause
exp "'%USER%/%PASSWORD%@%DATABASE% as sysdba'" tables=(%tableExp%) file=%DATADIR%\data_%filename%.dmp log=%LOGDIR%/log_%filename%.log
goto end 
:end
rem echo end  .........

~~~

#### 定时备份


计划任务：windows每晚自动运行数据库备份bat



## 三、RMAN备份及恢复

### 1、数据库/表空间备份

#### 备份

~~~sql
--查询数据库信息
show parameter name;

--登录rman（注意所用实例）
rman target 用户名/密码@实例名称 nocatalog;

--列出备份
list backup;
--列出数据库的备份
list backup of database;
--列出表空间的备份
list backup of tablespace EXAMPLE;

--备份数据库
backup database format '备份文件路径(dbf)';
--备份表空间
backup tablespace 表空间名称 format '备份文件路径(dbf)';

--注意：
--备份数据库、归档日志，并删除旧的归档日志。备份的归档日志会压缩，可以节省空间
backup database plus archivelog delete all input;
--未备份归档日志，删除旧的归档日志则无法恢复到备份以前的时间节点
backup database format '备份文件路径(dbf)';

--退出
exit;
~~~



#### 还原（完全恢复）

~~~sql
--查询数据库信息
show parameter name;

--登录rman（注意所用实例）
rman target 用户名/密码@实例名称;

--列出数据库的备份
list backup of database;

--还原
shutdown immediate;
--使数据库处于mount状态
startup mount;	

--还原数据库
restore database;
recover database;
alter database open;	--验证表空间恢复结果（日志重新归位）

--还原表空间
restore tablespace 表空间名称;
recover tablespace 表空间名称;
alter tablespace 表空间名称 online;

--退出
exit;
~~~

#### 还原（不完全恢复）

根据时间节点、日志序号等进行恢复

~~~sql
--查询数据库信息
show parameter name;

--登录rman（注意所用实例）
rman target 用户名/密码@实例名称;

--列出数据库的备份
list backup of database;

--还原
shutdown immediate;
startup mount;	--使数据库处于mount状态

--还原数据库
restore database;
recover database until time "to_date('2020-07-03 09:14:34','yyyy-mm-dd hh24:mi:ss')";
--验证表空间恢复结果（日志重新归位）
alter database open resetlogs;

--还原表空间
restore tablespace 表空间名称;
recover tablespace 表空间名称 until time "to_date('2020-07-03 09:14:34','yyyy-mm-dd hh24:mi:ss')";
alter tablespace 表空间名称 online resetlogs;

--退出
exit;
~~~

### 2、增量备份

以0级增量备份作为基础，后续1级增量备份都是相对于0级。

- 差异增量备份

差异备份是rman生成的增量备份的默认类型。对于差异备份来说，rman会备份自上一次同级或低级差异增量备份以来所有发生变化的数据块。

~~~sql
backup incremental level=1 database;
~~~

- 累计增量备份

使用累积备份可以使用备份集备份自上次0级备份以来所发生变化的数据块，忽略之前的1级备份。

~~~sql
backup incremental level=1 cumulative database;
~~~



### 3、注意事项