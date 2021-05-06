### 一、服务器SDE数据库配置

(此示例为服务器仅安装Oracle，从另一主机连接进行地理数据库的配置)

1. 服务器安装Oracle；

2. 复制st_shapelib.dll文件到服务器上，并更新extproc文件和相关表内容；

   ~~~sh
   # ORACLE_HOME\hs\admin\extproc.ora 文件对应位置添加
   “SET EXTPROC_DLLS=ONLY:C:\\mylibraries\\st_shapelib.dll”
   
   # 更新表内容
   CREATE OR REPLACE LIBRARY st_shapelib AS '…\st_shapelib.dll';
   ~~~

3. 在有arcgis的主机上，安装32位OracleClient，使用ArcCatalog连接Oracle；

![image-20200710150219213](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200710150219213.png)

4. 使用工具“创建企业级地理数据库”，创建SDE地理数据库；

![image-20200710150154423](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200710150154423.png)



### 二、地理数据库用户创建

1. **地理数据库管理员**

   创建企业级地理数据库时，创建的名称为“sde”的用户。地理数据库管理员的名称必须为“sde”。

2. **普通地理数据库用户**

​		实际应根据各项目需要，创建普通的的地理数据库用户。可使用arcgis的工具“创建数据库用户”进行项目的普通sde用户创建。

![image-20200710151646081](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200710151646081.png)



### 三、SDE备份还原

#### 1、使用arcgis进行备份还原

###### （1）arcgis工具导入导出

![image-20200713175730993](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200713175730993.png)

##### （2）Python脚本导入导出

#### 2、使用Oracle进行备份还原

##### （1）exp/imp、expdp/impdp备份还原

​		将原“sde”用户的数据导入到不同名称的用户中时，会产生报错，需额外对相关表处理。建议用导入导出的用户保持一致。先还原地理数据库管理员"sde"用户，再还原其他普通sde用户。

- exp/imp备份还原

~~~sh
# exp
exp user/passwd@ip/orcl file="D:\app\Administrator\oradata\…\Backup.dmp" owner=user log="log.txt"

# imp
imp user/passwd@ip/orcl file="D:\app\Administrator\oradata\…\Backup.dmp" log="log.txt" fromuser=sde touser=sde
~~~



- expdp/impdp备份还原

  ~~~sh
  #需在相应服务器上执行
  
  # expdp
  expdp user/passwd@ip/orcl dumpdirectory="" dumpfile="D:\app\Administrator\oradata\…\Backup.dmp" schemas=user logfile="log.txt"
  
  # impdp
  impdp user/passwd@ip/orcl dumpdirectory="" dumpfile="D:\app\Administrator\oradata\…\Backup.dmp" log="log.txt"
  ~~~




- expdp/impdp和exp/imp优缺点比较：

​		expdp/impdp：速度快

​		exp/imp：速度慢，不能导出空表，可以异地备份还原

##### （2）物理备份还原

​		备份还原需要停止实例，否则文件不一致，还原的数据库会存在问题。

##### （3）rman备份还原

### 四、注意事项

- **arcmap需适配32位数据库或32位客户端**

  - 32位/64位Oracle数据库和arcgis安装在不同的主机上时，arcgis主机上安装32位Oracle客户端；

  - 32位Oracle数据库和arcgis安装在同一台主机上时，可使用arcgis直连数据库；

  - 64位Oracle数据库和arcgis安装在同一台主机上时，需安装32位Oracle客户端；

    相应环境变量设置：

    ~~~
    Oracle_Home:	D:\app\user\product\11.2.0\client_1
    Path:			D:\app\191117\product\11.2.0\dbhome_1\bin
    				D:\app\191117\product\11.2.0\client_1\BIN
    ~~~

    Oracle_Home为client路径("D:\app\user\product\11.2.0\client_1")时，不能使用数据库管理工具，不能重启监听服务。

- **windows系统，OMS服务导致连接超上限**

  - 原因

    应该是打开过网页端管理，启动了OMS服务。很可能是Windows下的Bug，目前只能通过关闭该服务的方式避免。

    **OracleDBConsole服务 :** oem控制台的服务。可以以网页形式进行数据库管理，比如:http://localhost:1158/em/ ,再以sys登陆,就可以管理数据库了。

  - 解决方式

    关闭OracleDBConsoleORCL服务，设置为手动启用。

- **ST_Geometry警告**

  - 原因

    未正确添加ST_Geometry。对于需要在 Oracle 的地理数据库中依据 ST_Geometry 数据进行 SQL 查询的情况，可添加ST_Geometry文件

  - 解决方式

    将相应版本的st_shapelib.dll 文件放置在 Oracle 服务器上的目录中，

    配置Oracle extproc添加对st_shapelib.dll 文件的访问

    ~~~
    ORACLE_HOME\hs\admin\extproc.ora对应位置添加“SET EXTPROC_DLLS=ONLY:C:\\mylibraries\\st_shapelib.dll”
    ~~~

    更新文件路径配置

    ~~~sql
    CREATE OR REPLACE LIBRARY st_shapelib AS '…\st_shapelib.dll';
    ~~~

    
