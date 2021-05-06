# RMAN详细教程

作者：[WoLykos](https://home.cnblogs.com/u/WoLykos/)

## 第一部分	基本命令

### 一、target——连接数据库

#### 1、本地：

```sh
[oracle@oracle ~]$ rman target /
```

#### 2、远程：

```sh
[oracle@oracle ~]$ rman target sys/oracle@orcl 
```

　　
　

### 二、show——查看配置

RMAN> show all //总配置参数，具体看configure模块

```sh
CONFIGURE RETENTION POLICY TO REDUNDANCY 1; # default
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP OFF; # default
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; #default
CONFIGURE DEVICE TYPE DISK PARALLELISM 1; # default
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE SNAPSHOT CONTROLFILE NAME TO‘C:ORACLE..SNCFTEST.ORA’; #default
```

RMAN> show channel; // 通道分配
RMAN> show device type; // IO 设备类型
RMAN> show retention policy; // 保存策略
RMAN> show datafile backup copies; // 多个备份的拷贝数目
RMAN> show maxsetsize; // 备份集大小的最大值
RMAN> show exclude; // 不必备份的表空间
RMAN> show backup optimization; // 备份的优化
　
　

### 三、configure——调整配置

1、configure retention policy to redundancy 1；
舍弃备份原则，共三种，分别是：
（1）CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
保持所有足够的备份，可以将数据库系统恢复到最近七天内的任意时刻。任何超过最近七天的数据库备份将被标记为obsolete。
（2）CONFIGURE RETENTION POLICY TO REDUNDANCY 5;
保持可以恢复的最新的5份数据库备份，任何超过最新5份的备份都将被标记为redundancy。一般采用的方法，默认值为1，可以设置为5。
（3）CONFIGURE RETENTION POLICY TO NONE;
不需要保持策略，clear将恢复回默认的保持策略。
　
2、CONFIGURE BACKUP OPTIMIZATION OFF；
默认为关闭，如果打开，rman将对备份的数据文件及归档等文件进行一种优化的算法。
　
3、Configure default device type to disk；
默认值是硬盘，是指定所有I/O操作的设备类型是硬盘或者磁带(SBT)。
　
4、CONFIGURE CONTROLFILE AUTOBACKUP OFF；
强制数据库在备份文件或者执行改变数据库结构的命令之后将控制文件自动备份，默认值为关闭。这样在控制文件和catalog丢失后，控制文件仍然可以恢复。
　
5、CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'；
配置控制文件的备份路径和备份格式
　
6、CONFIGURE DEVICE TYPE DISK PARALLELISM 1;
配置数据库设备类型的并行度，默认为1。
　
7．CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1;
配置每次备份的copy数量。
　
8、CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1；
配置归档日志存放的设备类型。
　
9、configure maxsetsize 大小；
配置备份集的最大尺寸，默认值是unlimited，单位bytes,K,M,G；
　
10、CONFIGURE SNAPSHOT CONTROLFILE NAME TO 'C:ORACLE…SNCFTEST.ORA'；
配置控制文件的快照文件的存放路径和文件名，这个快照文件是在备份期间产生的，用于控制文件的读一致性。
　
11、CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT 'C:...%d_DB_%u_%s_%p';
配置备份文件的备份路径和备份格式。
　
12、CONFIGURE CHANNEL DISK CLEAR;
用于清除上面的信道配置。
　
13、CONFIGURE EXCLUDE FOR TABLESPACE [CLEAR];
不备份指定的表空间到备份集中，对只读表空间是非常有用的。
　
14、configure channel device type disk format 'e:\backupb%d_db_%u';
将备份文件存储到e:\backupb，后面的%d_db_%u是存储格式。
　
15、configure controlfile autobackup format for device type disk to 'e:\backupcontrol%F';
指定control file存储在另一个路径： e:\backupcontrol，后面的%F是存储格式。
　
　

### 四、List—— 列出备份集和数据文件镜像

1、list incarnation;
汇总查询，多备份文件时，可以对备份文件有个总体了解。
　
2、list backup;
列出备份详细信息。
　
3、list backup summary;
简述可用的备份（TY: B代表备份, LV: F代表全备fullbackup, A表示 Archivelog, 0,1,2 表示备份级别, S表示状态, A表示available可用, X表示expried过期）。

```
备份列表
===============
关键字     TY LV S 设备类型 完成时间   段数 副本数 压缩标记
------- -- -- - ----------- ---------- ------- ------- ---------- ---
11      B  F  A DISK        02-7月 -13 1       1       NO         TAG20130702T162726
12      B  F  A DISK        14-2月 -14 1       1       NO         TAG20140214T140119
13      B  F  A DISK        14-2月 -14 1       1       NO         TAG20140214T140119
14      B  F  A DISK        21-2月 -14 1       1       NO         TAG20140221T125325
15      B  F  A DISK        21-2月 -14 1       1       NO         TAG20140221T125325
16      B  A  A DISK        24-2月 -14 1       1       NO         TAG20140224T125128
```

　
4、list backup by file;
按照文件类型列出以下四种类型列表：
***数据文件备份列表、已存档的日志备份列表、控制文件备份列表、SPFILE 备份的列表。***
　
5、list backup of database summary;
　
6、list backup of tablespace users;
　
7、list backup of archivelog all;
查看已经备份的 archive log 情况。
　
8、list archivelog all;
查看目前所有的archivelog文件 (可能包含已经备份的, 除非你在备份时有参数 delete input file 删除了)。
　
9、list backup of spfile;
　
10、list backup of controlfile;
　
11、list backup verbose;
　
12、list backup of datafile 1 [n | <dir>];
　
13、list backup of archivelog from sequence 1000 until sequence 1020;
　
14、list backupset tag=TAG20140317T155753;
　
15、list expried backup;
列出过去的备份文件。
　
　

### 五、Report——显示存储仓库(Repository)中详细的分析信息

1、report schema;
报告目标数据库的物理结构。
　
2、report need backup;
报告需要备份的数据文件(根据条件不同)。
　
3、report need backup days 3;
最近三天没有备份的数据文件(如果出问题的话，这些数据文件将需要最近3天的归档日志才能恢复)。
　
4、report need backup redundancy 3;
报告出冗余次数小于3的数据文件。
　
5、report need backup recovery window of 3 days;
报告出恢复需要3天归档日志的数据文件。
　
6、report obsolete;
报告已经丢弃的备份(前提是设置了备份策略)。
　
7、report unrecoverable;
报告当前数据库中不可恢复的数据文件(即没有这个数据文件的备份、或者该数据文件的备份已经过期)。
　
8、report schema at time ‘sysdate – 7’;
　
9、report need backup days 2 tablespace system;
　
　

### 六、Delete——删除相关的备份集或镜像副本的物理文件, 同时将删除标记 delete 更新到控制文件。

```sql
delete backupset;
delete backupset n;
delete obsolete;   -- 删除荒废
delete noprompt obsolete;  -- 不提示, 删除荒废
delete noprompt expired backup;  -- 不提示, 删除不在磁盘上的备份集(可以先用crosscheck同步确认一下)
delete obsolete redundancy 2;
delete noprompt copy
delete noprompt backupset tag TAG20140317T14432;
delete obsolete recovery window of 7 days;
delete expired backupset;
delete expired copy;
delete expired archivelog all;
```

　
　

### 七、Crosscheck——设置状态为AVAILABLE(可用)或者EXPIRED(不可用)

执行crosscheck时，RMAN检查目录中列出的每个备份集或副本并且判断他们是否存在与备份介质上。
如果备份集或副本不存在与备份介质上，它就会被标记为expired, 并且不能用于任何还原操作；
如果备份集或副本存在与备份介质上，它就会维持available状态。
如果以前被标记为expired 的备份集或副本再次存在于备份介质上，crosscheck 命令就会将它标记回available。
　
1、RMAN 备份检验的几种状态：
expired: 对象不存在于磁盘或磁带。
available: 对象处于可用状态。
unavailabe: 对象处于不可用状态。
　
2、expired 与 obsolette 的区别:
（1）对于EXPIRED状态，与crosscheck命令是密切相关的，RMAN通过crosscheck命令检查备份是否存在于备份介质上, 如果不存在，则状态由AVAILABLE改为EXPIRED。
（2）对于obsolete状态，是针对MAN备份保留策略来说的，超过了这个保留策略的备份，会被标记为obsolete，但其状态依旧为AVAILABLE，我们可以使用report obsolete来查看已废弃的备份。
　

```sql
RMAN>crosscheck backup; --校验备份片（？？？）
RMAN> crosscheck backupset; --校验备份集
RMAN> crosscheck copy； --校验镜像副本
RMAN> crosscheck backup of controlfile; --校验备份的控制文件
RMAN> crosscheck backup of archivelog all; --校验所有备份的归档日志
RMAN> crosscheck backup of datafile 1,2; --校验datafile 1,2
RMAN> crosscheck backup of tablespace sysaux,system; --校验表空间sysaux,system
RMAN> crosscheck backup completed between '13-OCT-10' and '23-OCT-10'; --校验时间段,时间段格式由NLS_DATE_FORMAT设置
RMAN> crosscheck backupset 1067,1068; --校验指定的备份集
```

　
　

### 八、backup常用命令

1、将备份集放到快速恢复区中：
1)归档模式下：

```sh
backup database plus archivelog;
```

2)非归档模式下：

```sh
shutdown immediate;   # 关闭一致性后，打开到mount状态
backup database
```


2、指定备份片段的存放路径和命名规则：

```sh
backup format '/u01/app/oracle/oradata/enmo1/AL_%d/%t/%s/%p' archivelog like '%arc_dest%';
```


3、备份成镜像文件：

```sh
backup as copy
```


4、设置备份标记（每个标记必须唯一，相同的标记可以用于多个备份只还原最新的备份）。

```sh
backup database tag='full_bak1';
```

　
5、设置备份集大小（必须大于数据库总数据文件的大小，否则会报错）。

```sh
backup database maxsetsize=100m tag='datafile1';
```

　
6、设置备份片大小(磁带或文件系统限制)

```sh
run {
    allocate channel c1 type disk maxpicecsize 100m format '/data/backup/full_0_%U_%T';        
    backup database tag='full_0';        
    release channel c1;        
} 
```

**PS：**
可以在allocate子句中设定每个备份片的大小，以达到磁带或系统限制。
也可以在configure中设置备份片大小。

```sh
Configure channel device type disk maxpiecesize 100 m        
Configure channel device type disk clear;
```


7、备份集的保存策略

```sh
backup database keep forever;  #永久保留备份文件, 这种需要有恢复目录的支持
backup database keep until time='sysdate+30'; #保存备份30天
```


8、重写configure exclude命令

```sh
backup databas noexclude keep forever tag='test backup';
```


9、检查数据库错误

```sh
backup validate database; 
```

使用RMAN来扫描数据库的物理/逻辑错误，并不执行实际备份。
　
10、跳过脱机，不可存取或只读文件

```sh
backup database skip readonly;
backup database skip offline;
backup database skip inaccessible;
backup database ship readonly skip offline ship inaccessible;
```


11、强制备份

```sh
backup database force;
```


12、基于上次备份时间备份数据文件
（1）只备份添加的新数据文件：

```sh
backup database not backed up;
```

（2）备份"在限定时间周期内"没有被备份的数据文件：

```sh
backup database not backed up since time='sysdate-2';
```


13、备份操作期间检查逻辑错误

```sh
backup check logical database;
backup validate check logical database;
```


14、生成备份副本

```sh
backup database copies=2;
```


15、备份控制文件

```sh
backup database device type disk includ current controlfile;
```

　
　

### 九、Format参数

%a：Oracle数据库的activation ID即RESETLOG_ID。
%c：备份片段的复制数（从1开始编号，最大不超过256）。
%d：Oracle数据库名称。
%D：当前时间中的日，格式为DD。
%e：归档序号。
%f：绝对文件编号。
%F：基于"DBID+时间"确定的唯一名称，格式的形式为c-IIIIIIIIII-YYYYMMDD-QQ,其中IIIIIIIIII 为该数据库的DBID，YYYYMMDD为日期，QQ是一个1～256的序列。
%h：归档日志线程号。
%I：Oracle数据库的DBID。
%M：当前时间中的月，格式为MM。
%N：表空间名称。
%n：数据库名称，并且会在右侧用x字符进行填充，使其保持长度为8。
%p：备份集中备份片段的编号，从1开始。
%s：备份集号。
%t：备份集时间戳。
%T：当前时间的年月日格式（YYYYMMDD）。
%u：是一个由备份集编号和建立时间压缩后组成的8字符名称。利用%u可以为每个备份集生成一个唯一的名称。
%U：默认是%u_%p_%c的简写形式，利用它可以为每一个备份片段（即磁盘文件）生成一个唯一名称，这是最常用的命名方式。执行不同备份操作时，生成的规则也不同，如下所示：

```
生成备份片段时，%U=%u_%p_%c；
生成数据文件镜像复制时，%U=data-D-%d_id-%I_TS-%N_FNO-%f_%u；
生成归档文件镜像复制时，%U=arch-D_%d-id-%I_S-%e_T-%h_A-%a_%u；
生成控制文件镜像复制时，%U=cf-D_%d-id-%I_%u。
```

%Y：当前时间中的年，格式为YYYY。
**PS：**
如果在BACKUP命令中没有指定FORMAT选项，则RMAN默认使用%U为备份片段命名。

## 第二部分	备份、检查、维护、恢复

### 一、创建增量备份

增量备份级别为0-4，但为方便备份管理，oracle建议只限于0级和1级。

#### 1、差异增量备份(differential incremental backup)(默认)：

每次备份至上一次备份级别小于等于当前级别的备份。
![img](https://img2018.cnblogs.com/blog/1346146/201910/1346146-20191016104145127-1327158284.png)
　　

#### 2、累计增量备份(cumulative incremental backup)：

1)每次备份至上一次小于当前级别的备份；
![img](https://img2018.cnblogs.com/blog/1346146/201910/1346146-20191016104157072-48175879.png)
2)增量备份需要先进行一次0级备份，作为备份的起点。
　　

#### 3、增量备份例子：

```
backup incremental level 0 database;----0级增量备份，作为增量备份策略的基础
backup incremental level 1 cumulative database;----1级累积增量备份
backup incremental level 1 database;----1级差异增量备份
```

　　
　　

### 二、创建增量更新备份

#### 1、前提条件：

1)以0级数据文件镜像作为基础；
2)1级差异增量备份的标签需要和0级一致；
3)增量备份被应用到0级镜像上。
　　

#### 2、命令例子：

```
backup for recover of copy----只备份从上一个相同标签的备份以来发生数据块改变的增量备份
backup incremental level 0 for recover of copy tag 'test' database; ----使用tag标记数据文件镜像作为备份策略基础
recover copy of database with tag 'test';----增量更新备份
```

　　
　　

### 三、数据库文件和备份的检查

#### 1、有效性(数据文件是否存在于正确的路径下，并且是否存在物理块损坏)：

1)检查是否存在逻辑块损坏：
`check logical`
2)在备份时，对数据文件和归档日志文件进行检查：
`backup validate check logical database archivelog all;`
3)支持对数据文件中的数据库进行检查：
`validate datafile 4 block 10 to 30;`
4)支持对数据库备份集进行验证：
`validate backupset 3;`
　　

#### 2、引用脚本文件执行任务：

1)`RMAN @/my_dir/test.txt`
2)或登陆RMAN后`@/my_dir/test.txt`
　　

#### 3、列出RMAN备份信息——list：

1)`list backup of database by backup;`
2)`list backup by file;`
3)`list backup summary;`
4)`list expired backupset/copy;`
5)`list backup recoverable;`
　　

#### 4、列出RMAN备份信息——report：

1)`report need backup database;`----列出当前需要备份的数据文件
2)`report obsolete;`
3)`report schema;`
4)`report unrecoverable;`
　　

#### 5、备份相关的动态性能表：

```
v$archived_log：本视图包含了所有归档重做日志文件的创建情况，备份情况以及其他信息。
v$backup_corruption：这个视图显示了rman在哪些备份集中发现了损坏的数据块。
v$copy_corruptio：本视图显示了哪些镜像复制备份文件已经被损坏。
v$backup_datafile：本视图通常用来获取每个数据文件中非空白数据块的数量，
从而帮助你创建出大小基本相等的备份集。另外，在视图中也包含了数据文件中损坏的数据块的信息。
v$backup_redolog：本视图显示了在现有的备份集中饮食有哪些归档重做日志文件。
v$backup_set：本视图显示了已经创建的备份集的信息。
v$backup_piece：本视图显示了已经创建的备份片段的信息。 
```

　　
　　

### 四、维护RMAN备份

#### 1、同步数据库备份和镜像的逻辑记录——crosscheck：

1)`crosscheck backup;`
2)`crosscheck copy;`
　　

#### 2、删除备份信息——delete：

1)删除陈旧备份：
`RMAN> delete obsolete;`
2)删除expired备份：
`RMAN> delete expired backup;`
3)删除 expired 副本：
`RMAN> delete expired copy;`
4)删除特定备份集：
`RMAN> delete backupset 19;`
5)删除特定备份片：
`RMAN> delete backuppiece 'd:\backup\DEMO_19.bak';`
6)删除所有备份集：
`RMAN> delete backup;`
7)删除特定映像副本：
`RMAN> delete datafilecopy 'd:\backup\DEMO_19.bak';`
8)删除所有映像副本：
`RMAN> delete copy;`
9)在备份后删除输入对象：

```
RMAN> delete archivelog all delete input;
RMAN> delete backupset 22 format = ''d:\backup\%u.bak'' delete input; 
```

　　

#### 3、还原和恢复数据库文件：

1)还原是指从所有的备份或镜像文件中找到一个用于恢复操作的数据文件。
2)恢复是指在还原的数据文件上应用redo日志或增量备份中记录的变化，使得数据文件向前滚到一个SCN值或者一个时间点。
3)在对数据库进行还原恢复操作时，可以先进行预览：
`restore database preview summary;`
4)恢复整个数据库：

```
startup force mount;----将数据库至于mount状态
restore database;----还原数据库
recover database;----恢复数据库
alter database open;
```

5)恢复表空间：

```
alter tablespace users offline;---- 将表空间涉及的数据文件离线
restore tablespace; ----还原表空间
recover tablespace; ----恢复表空间
alter tablespace users online; ----恢复完成后，再设为在线
```

6)对数据坏块进行恢复：

```
recover corruption list;----修复所有的坏块
recover datafile 1 block 33, 44 datafile 2 blocke 1 to 200;
```

**PS：**
***坏块会记录到V$DATABASE_BLOCK_CORRUPTION视图中，还会记录在告警日志和TRACE文件中，可以通过V$DIAG_INFO查看这些文件的位置，找到相关文件进行坏块查看。***
　　
　　

### 五、数据恢复建议器(data recovery advisor)

1)列出当前失败并确定修复选项：oracle中失败是指被Health Monitor监测到的数据损坏，例如逻辑或物理的数据块损坏、数据文件丢失等；
2)监测到的失败有不同的优先级(critical、hight和low)，还有状态(open和closed)；
3)通过list failure可以查看当前监测到的失败，若在同一会话中执行advise failure命令，数据库会列出手工和自动的修复选项以供选择。
4)一般首先通过手工修复方式来进行修复，若手工修复不成功，再进行自动修复。
　　
　　

### 六、闪回数据库技术

1)想使用闪回数据库技术，需要先开启闪回日志功能。(闪回日志只能存放在快速恢复区中，并且不会进行归档)
2)闪回数据库不能用于介质恢复和修复数据文件的丢失。
3)闪回数据库需要在mount状态下进行。
4)命令：

```
shutdown immediate ;----调整至mount状态 
startup mount;
flashback database to scn 1526845;----闪回到过去的某时刻
flashback database to restore point before_points;
flashback database to timestamp to_date('20140510','yyyymmdd');
alter database read only;----将数据库置为只读状态，进行验证
shutdown immediate;----若闪回后满足要求，启动数据库
startup mount;
alter database open resetlogs;
```

　　
　　

### 七、指令运行方式

#### 1、单个执行：

```
RMAN>backup database;
```

#### 2、批处理：

```
RMAN>run{
.......................
.......................
}
```

***这种方式是最常使用的方式，特别对于后台执行。***
***好处是如果作业中任何一条命令执行失败，则整个命令停止执行。***
　　

#### 3、运行脚本：

1)`[oracle@oracle ~]$ rman target / @backup_db.rman`
2)`RMAN> @backup_db.rman`
3)`RMAN> run { @backup_db.rman }`
4)运行存储在恢复目录中的脚本(需要首先为rman 创建恢复目录)：
`RMAN> run { execute script backup_whole_db };`
`[oracle@oracle ~]$rman cmdfile=backup_db.rman;`

## 第三部分	备份脚本的组件和注释

### 一、基本组件：

#### 1、Server session：

服务器会话，服务器上的进程, 是真正用来干活的；
　

#### 2、Channel：

是一个通道, 用来连接数据库与备份的存储介质；
通道配置选项：

```
connect :是一个Oracle Net连接串。一般不适用于单实例环境
format : 为通道创建的备份片或映像副本确定路径与文件名
duration: 控制作业的时间总量，以小时和分钟进行指定
maxopenfiles:该选项限制RMAN一次能够打开的输入文件数，默认为
maxpiecesize:限制一个备份集分割的备份片的大小，以字节(默认)、k、m、g为单位
parms:能够被用于设置sbt_type通道所需的任何变量
filesperset:备份集中可容纳的文件数
backup set: 是一个集合, 是由一个或多个物理文件组成, 是一个逻辑单位.
backup piece: 是真正的一个输出文件, 受到操作系统单个文件的限制, 即 maxpiecesize 这个参数；
```

　

#### 3、backuppiece：

备份片，表示一个由RMAN产生备份的文件.用OS工具可以实实在在的看到；
　

#### 4、backupset：

备份集，表示进行一次备份所产生的所有备份片集合,是一个逻辑上的概念；
***一个数据文件可以跨备份片存在,而不能跨备份集存在。***
　
　

### 二、基本作业模板：

#### 示例1：

```sh
RMAN> run
{
allocate channel c1 device type disk maxpiecesize 1500m;
backup database plus archivelog delete all input;
release channel c1;
}
```

allocate channel命令在目标数据库启动一个服务器进程，同时必须定义服务器进程执行备份或者恢复操作使用的I/O类型。
每个备份片的最大为1500M,超过这个大小就会产生新的备份片,在启动备份时,会归档当前的日志,生成一个备份片,删除已备份的归档日志.然后备份数据文件,生成两个备份片(数据文件2G),再备份当前的SPFILE 和CONTROLFILE,生成一个备份片,最后再做一次LOGSWITCH,备份归档日志,生成一个备份片,因此可以这样描述,这个备份集包含成五个备份片，一个备份片包含文件个数由 FILESPERSET 指定.
　

#### 示例2：

```sh
RMAN> run
{
allocate channel c1 device type disk maxpiecesize 1500m;
backup database filesperset 1;
release channel c1;
}
```

表示一个备份片中包含一个文件,即使没有达到 1500M,也生成新的备份片,如我的有五个数据文件,还有 SPFILE和 CONTROLFILE 一个备份片,一共生成六个备份片.如果加上plus archivelog delete all input这个备份选项,那 FIELSPERSET 这个参数就会被IGNORE掉。
　
　

### 三、RMAN备份脚本：

#### 1、全备:

$cat arch_rman_backup.sh:

```sh
source /home/oracle/.bash_profile
rman target / log=/u01/app/script/arch_rman.log<<EOF
run
{
allocate channel ch1 device type disk; 
allocate channel ch2 device type disk;
sql 'alter system archive log current';  
sql 'alter system archive log current';
backup archivelog all format '/backup/arch_%U_%d_%T_%t' delete all input;
backup current controlfile format '/backup/ctl_%U_%d_%T_%t';
crosscheck backup;
crosscheck archivelog all;
delete noprompt expired backup;
delete noprompt obsolete;
#delete noprompt backup of database completed before 'sysdate -7';
#delete noprompt archivelog all;
#delete noprompt backup of archivelog all completed before 'sysdate -7';
release channel ch1;
release channel ch2;
}
EOF
```

　

#### 2、归档日志备份：

$cat arch_rman_backup.sh

```sh
source /home/oracle/.bash_profile
rman target / log=/u01/app/script/arch_rman.log<<EOF
run
{
allocate channel ch1 device type disk; 
allocate channel ch2 device type disk;
sql 'alter system archive log current'; 
#backup database format '/backup/db_%d_%T_%U';
sql 'alter system archive log current';
backup archivelog all format '/backup/arch_%U_%d_%T_%t' delete all input;
backup current controlfile format '/backup/ctl_%U_%d_%T_%t';
crosscheck backup;
crosscheck archivelog all;
delete noprompt expired backup;
delete noprompt obsolete;
#delete noprompt backup of database completed before 'sysdate -7';
#delete noprompt archivelog all;
#delete noprompt backup of archivelog all completed before 'sysdate -7';
release channel ch1;
release channel ch2;
}
EOF
```

## 第四部分	备份脚本实战操作

#### 1、为了安全起见，先将数据库完全导出：

```
exp 用户名/密码@ORACLE file=/backup/ecology_$(date　'+%Y%m%d').dmp full=y;
```

#### 2、因为是数据库操作，所以应切换成Oracle用户：

```
su - oracle
```

#### 3、检查数据库是否打开归档模式，如否，则打开SQLPLUS执行以下命令：

```
archive log list;
alter system set log_archive_dest_n='location=/u01/backupws ';
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;
```

　

#### 4、将rman脚本文件放置到`backup_sh`目录下：

(1)全库备份（一周三次）
rman_ecology_all.sh

```
run {
    allocate channel a1 device type disk format '/backup/ecology_all_%T_%u';
    allocate channel a2 device type disk format '/backup/ecology_all_%T_%u';
    backup database skip offline plus archivelog delete all input;
    backup current controlfile;
    release channel a1;
    release channel a2;
}
    allocate channel for maintenance device type disk;
    delete obsolete;
    crosscheck backupset;
```

　
(2)归档日志备份（一周四次）
rman_ecology_arc.sh

```
run {
    allocate channel b1 device type disk format '/backup/ecology_arc_%T_%u';
    allocate channel b2 device type disk format '/backup/ecology_arc_%T_%u';
    backup archivelog all;
    backup current controlfile;
    release channel b1;
    release channel b2;
}
    allocate channel for maintenance device type disk;
    crosscheck backupset;
```

　

#### 5、编写RMAN脚本的运行脚本：

`mkdir -p /backup/` # 创建目录(-p表示不存在则新建，若存在则忽略)
`touch run_rman_ecology_all.sh` # 创建all运行脚本
`touch run_rman_ecology_arc.sh` # 创建arc运行脚本

```
vi run_rman_ecology_all.sh

export ORACLE_HOME=/u01/app/oracle/product/10.2/db_1
export ORACLE_SID=ecology
/u01/app/oracle/product/10.2/db_1/bin/rman target / log=/backup/all_ecology_$(date +%F).log cmdfile=/backup_sh/rman_ecology_all.sh
vi run_rman_ecology_arc.sh

export ORACLE_HOME=/u01/app/oracle/product/10.2/db_1
export ORACLE_SID=ecology
/u01/app/oracle/product/10.2/db_1/bin/rman target / log=/backup/arc_ecology_$(date +%F).log cmdfile=/backup_sh/rman_ecology_arc.sh
```

　

#### 6、添加执行权限：

`chmod +x /backup_sh/run_rman_ecology_all.sh`
`chmod +x /backup_sh/run_rman_ecology_arc.sh`
**PS：**
***需使用root用户。***
　

#### 7、手动测试脚本，成功之后再下一步。

若报错，则直接打开`/var/spool/mail/登陆用户名`，查看日志并改正。
　

#### 8、添加定时任务:

***周三五七晚20:00全库，周一二四六晚20:00归档日志***

```
crontab -e

00 20 * * 0,3,5 sh /backup_sh/run_rman_ecology_all.sh >> /backup/rman_crontab_all.log 2>&1
00 20 * * 1,2,4,6 sh /backup_sh/run_rman_ecology_arc.sh >> /backup/rman_crontab_arc.log 2>&1
```

***格式是“分 时 日 月 周 要执行的命令或脚本”。***
　

#### 9、重启计划任务：

```
service cron restart
```