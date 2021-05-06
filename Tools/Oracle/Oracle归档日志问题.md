# Oracle归档日志已满解决方法及扩容方式

**首先可以以dba用户登录oracle：**
sqlplus / as sysdba

**然后可以使用以下几个命令可以查看当前归档日志文件的使用情况：**
select * from v$recovery_file_dest;
![在这里插入图片描述](https://img-blog.csdnimg.cn/20181122093436897.png)
可以看到归档日志文件目录、最大值（已经设定为20G）、当前使用值

select * from v$flash_recovery_area_usage;
![在这里插入图片描述](https://img-blog.csdnimg.cn/20181122093744739.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl8yOTcxODQ2OQ==,size_16,color_FFFFFF,t_70)
可以看到ARCHIVED LOG的使用率是0%，这是因为我已经删除归档日志文件了。

**接下来进入rman程序删除归档日志：**
rman target 用户名/密码@数据库名

![在这里插入图片描述](https://img-blog.csdnimg.cn/20181122094243222.png)
crosscheck archivelog all;–检查控制文件和实际物理文件区别
delete archivelog until time ‘sysdate’; --删除所有日志
delete expired archivelog all;–删除过期日志

**若归档日志不够大，也可以扩大归档日志容量：**
alter system set db_recovery_file_dest_size=81474836480;－－设置使用空间大小
show parameter db_recovery_file_dest;－－查看归档日志路径限额