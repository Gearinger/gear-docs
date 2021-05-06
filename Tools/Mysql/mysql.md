### 一、下载Mysql

### 二、安装Mysql

~~~sh
# 以管理员运行命令行，并切换到mysql的bin目录
cd ./bin

# 安装mysql
mysqld --install

# 初始化，并记录初始密码
mysqld --initialize --console

# 开启服务
net start mysql

# 登录并修改初始密码
mysql -u root -p
alter user 'root'@'localhost' identified by 'root';

# 登录测试
mysql -u root -p

# 添加mysql环境变量

~~~

