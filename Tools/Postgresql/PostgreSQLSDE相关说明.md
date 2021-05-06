### 一、服务器SDE数据库配置

#### 1、将 st_geometry 库复制到 PostgreSQL 安装目录

​		将 st_geometry.dll 文件从 ArcGIS 客户端移动到 PostgreSQL 服务器上 PostgreSQL 的 lib 目录。

#### 2、首次创建企业级地理数据库

​		利用arcgis工具"创建企业级地理数据库"

![image-20200713181716945](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200713181716945.png)

#### 3、后续创建企业级地理数据库

- 在 postgregis 中创建数据库

  ~~~sql
  CREATE DATABASE "testsde2"
  WITH
    OWNER = "testuser1"
    TABLESPACE = "SDETS"
  ;
  ~~~

- arcgis 启用地理数据库

  ![image-20200713181039045](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200713181039045.png)



### 二、地理数据库用户创建

**用户创建区别：**用 arcgis 创建用户和用 postgresql 创建用户无区别

1. **地理数据库管理员**

   创建企业级地理数据库时，创建的名称为“sde”的用户。地理数据库管理员的名称必须为“sde”。

2. **普通地理数据库用户**

​		用 arcgis 创建用户和用 postgresql 创建用户无区别。



### 三、SDE备份还原

#### 1、使用arcgis进行备份还原

- arcgis 工具导入导出

- Python 脚本导入导出

#### 2、使用postgresql进行备份还原

​		pg_dump/ pdrestore

~~~
//全局备份
pg_dump all –h localhost –U username –p 5432 –g –f xxx/global.sql
//全局还原

//指定数据库备份
pg_dump –h localhost –U username –p 5432 –d dbname  –C  –f xxx/xxxdb.sql
//指定数据库还原
~~~

