# 达梦数据库SDE

## 地理数据初始化

#### 初始化

~~~sql
SP_INIT_GEO_SYS(1);
~~~

#### 检查初始化是否成功

~~~sql
SELECT SF_CHECK_GEO_SYS;
~~~



## arcgis版本适配

#### arcmap连接示例（其他示例见：[官网说明](https://desktop.arcgis.com/zh-cn/arcmap/latest/manage-data/databases/connect-dameng.htm)）

1. 配置DM_HOME、PATH环境变量

![image-20200708104541887](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200708104541887.png)

![image-20200708104602732](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200708104602732.png)

2. 配置arcgis数据库连接

![image-20200708104158726](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200708104158726.png)

注：datasource支持连接字符串，示例：SERVER=127.0.0.1; TCP_PORT=5236。

以下为datasource格式说明（详情见[开发文档](dm8相关文档/DM8程序员手册.pdf)）：

|      名称      |                             说明                             |
| :------------: | :----------------------------------------------------------: |
|     DRIVER     |                              DM                              |
|      ODBC      |             DM ODBC 驱动的名字：DM8 ODBC DRIVER              |
|     SERVER     |                目标服务器，ip 地址或者服务名                 |
|    TCP_PORT    |                            端口号                            |
|      UID       |                            用户名                            |
|      PWD       |                             密码                             |
| CHARACTER_CODE | 编码信息 ： PG_UTF8/PG_GB18030 ， PG_BIG5 ， PG_ISO_8859_9 ， PG_EUC_JP ， PG_EUC_KR ， PG_KOI8R ， PG_ISO_8859_1 ， PG_ISO_8859_11 |
|       …        |                              …                               |



#### arcgis版本支持

ArcGIS从ArcGIS10.4.X以上开始支持连接达梦数据库。

|   Arcgis版本   |      支持的达梦数据库版本（包括此版本或以上）      |
| :------------: | :------------------------------------------------: |
|  ArcGIS 10.4   |                   Dameng v7.1.5                    |
|  ArcGIS 10.5   |                   Dameng v7.1.5                    |
| ArcGIS 10.5.1  |                 Dameng v7.1.5.158                  |
|  ArcGIS 10.6   | Dameng v7.1.5、Dameng v7.1.5.158、Dameng v7.1.6.33 |
| ArcGIS 10.7.x  |                   Dameng V7.1.6                    |
|  ArcGIS 10.8   |                   Dameng V7.1.6                    |
| ArcGIS Pro 2.3 |                   Dameng V7.1.5                    |
| ArcGIS Pro 2.4 |                   Dameng V7.1.5                    |
| ArcGIS Pro 2.5 |                   Dameng V7.1.5                    |



**注意事项及缺少的功能：**

- 服务器端可使用32位/64位达梦数据库，客户端主机必须安装32位达梦数据库客户端
- Dameng 不支持使用arcgis客户端创建用户、角色等相关功能
- 新建项只有要素类、表、视图，缺少要素集和栅格数据的支持

![image-20200708103105725](C:\Users\191117\AppData\Roaming\Typora\typora-user-images\image-20200708103105725.png)

- 升级企业级地理数据库暂未测试，未知