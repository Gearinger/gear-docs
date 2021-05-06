## 角色

oracle提供三种标准角色（role）:connect/resource和dba.**

**connect role(连接角色)**
临时用户，特指不需要建表的用户，通常只赋予他们connect role.

connect是使用oracle简单权限，这种权限只对其他用户的表有访问权限，包括select/insert/update和delete等。
拥有connect role 的用户还能够创建表、视图、序列（sequence）、簇（cluster）、同义词(synonym)、回话（session）和其他 数据的链（link)。

**resource role(资源角色)**
更可靠和正式的数据库用户可以授予resource role。

resource提供给用户另外的权限以创建他们自己的表、序列、过程(procedure)、触发器(trigger)、索引(index)和簇(cluster)。

**dba role(数据库管理员角色)**
dba role拥有所有的系统权限

包括无限制的空间限额和给其他用户授予各种权限的能力。



## 备份还原

- expdp、impdp（逻辑备份）
- 物理备份（冷备）
- rman备份（热备）



## sqlplus的使用

~~~shell
//登录
connect sys/passwd@orcl as sysdba;

//关闭
shutdown immediate

//启动到mount状态
startup mount

//完全启动
startup
~~~



### 创建用户

#### 创建用户

```sql
create user student          --用户名
  identified by "123456"     --密码
  default tablespace USERS   --表空间名
  temporary tablespace temp  --临时表空间名
  profile DEFAULT            --使用默认数据文件
  account unlock;            --解锁账户（lock:锁定、unlock解锁）

alter user STUDENT
  identified by "654321"    --修改密码
  account lock;             --修改锁定状态（LOCK|UNLOCK ）
```

#### 分配权限

系统权限：create session数据库连接权限、create table、create view 等创建数据库对象权限。由DBA用户授权。

对象权限：对表中数据进行增删改查操作，对所拥有的对象进行相应的操作。由拥有该对象权限的对象授权。

```sql
# 授权
--GRANT 对象权限 on 对象 TO 用户
grant select, insert, update, delete on JSQUSER to STUDENT;
 
--GRANT 系统权限 to 用户
grant select any table to STUDENT;

# 取消
-- Revoke 对象权限 on 对象 from 用户
revoke select, insert, update, delete on JSQUSER from STUDENT;

-- Revoke 系统权限 from 用户
revoke SELECT ANY TABLE from STUDENT;
```

#### 设置角色

CONNECT角色：基本角色。CONNECT角色代表着用户可以连接 Oracle 服务器，建立会话。

RESOURCE角色：开发过程中常用的角色。RESOURCE角色可以创建自己的对象，包括：表、视图、序列、过程、触发器、索引、包、类型等。

DBA角色：管理数据库管理员角色。拥有所有权限，包括给其他用户授权的权限。SYSTEM用户就具有DBA权限。

```sql
# 授权
--GRANT 角色 TO 用户
grant connect to STUDENT;
grant resource to STUDENT;

# 取消
-- Revoke 角色 from 用户
revoke RESOURCE from STUDENT;
```



## 其他

数据库启动(startup)包括的三个状态：

+ nomount

+ mount

  ~~~sql
  startup mount;
  ~~~

+ open

  ~~~sql
  alter database open;
  ~~~

