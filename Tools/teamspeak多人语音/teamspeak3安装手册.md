# [ts3server 在 centos7 下架设流程](http://www.orzwtf.cn/default/2019-08-15-ts3server.html)

August 15th , 2019

### 环境

```
Centos7
```

### 前提

```
root@teamspeak:~# yum -y update
root@teamspeak:~# yum -y install nano wget perl tar net-tools bzip2
```

### 添加用户

```
root@teamspeak:~# useradd teamspeak
root@teamspeak:~# passwd teamspeak
```

### 下载 https://www.teamspeak.com/en/downloads/#server

```
root@teamspeak:~# cd /home
root@teamspeak:~# md teamspeak
root@teamspeak:~# cd teamspeak
root@teamspeak:~# wget https://files.teamspeak-services.com/releases/server/3.12.1/teamspeak3-server_linux_amd64-3.12.1.tar.bz2
root@teamspeak:~# tar -xvf teamspeak3-server_linux_amd64-3.12.1.tar.bz2
root@teamspeak:~# mv teamspeak3-server_linux_amd64 teamspeak3
```

### 记得将所有权交给专属用户

```
root@teamspeak:~# chown -R teamspeak:teamspeak /home/teamspeak/teamspeak3/
```

### 接受协议(软件目录生成此文件)

```
root@teamspeak:~# cd teamspeak3
root@teamspeak:~# touch .ts3server_license_accepted
```

### 防火墙允许端口通过

# iptables

```
root@teamspeak:~# iptables -A INPUT -p udp --dport 9987 -j ACCEPT
root@teamspeak:~# iptables -A INPUT -p tcp --dport 10011 -j ACCEPT
root@teamspeak:~# iptables -A INPUT -p tcp --dport 30033 -j ACCEPT
```

# ufw

```
root@teamspeak:~# ufw allow 9987/udp
root@teamspeak:~# ufw allow 10011/tcp
root@teamspeak:~# ufw allow 30033/tcp
```

# firewalld

```
root@teamspeak:~# systemctl start firewalld
root@teamspeak:~# firewall-cmd --zone=public --add-port=9987/udp --permanent
root@teamspeak:~# firewall-cmd --zone=public --add-port=10011/tcp --permanent
root@teamspeak:~# firewall-cmd --zone=public --add-port=30033/tcp --permanent
root@teamspeak:~# firewall-cmd --reload
```

### 服务配置

```
root@teamspeak:~# vim /lib/systemd/system/teamspeak.service
```

# 适当根据目录修改

```
[Unit]
Description=Team Speak 3 Server
After=network.target
 
[Service]
WorkingDirectory=/home/teamspeak/teamspeak3/
User=teamspeak
Group=teamspeak
Type=forking
ExecStart=/home/teamspeak/teamspeak3/ts3server_startscript.sh start inifile=ts3server.ini
ExecStop=/home/teamspeak/teamspeak3/ts3server_startscript.sh stop
PIDFile=/home/teamspeak/teamspeak3/ts3server.pid
RestartSec=15
Restart=always
 
[Install]
WantedBy=multi-user.target
```

### 启动TS服务

```
root@teamspeak:~# systemctl start teamspeak.service
root@teamspeak:~# systemctl enable teamspeak.service
```

### 确保TeamSpeak服务正确运行

```
root@teamspeak:~# systemctl status teamspeak.service
```

### TS服务器第一次运行时，会生成一个一次性的权限密钥，用于给你本地端设置管理员权限。

```
root@teamspeak:~# cat /home/teamspeak/teamspeak3/logs/ts3server_*
```

### 客户端 https://www.teamspeak.com/en/downloads/#client

### 如何启用高级权限系统？

```
默认的权限设置是通过常用模板来设置的，有时需要进行更细致的设置时就不够用了，管理员需要启用“高级权限系统”。
点击工具->选项->基本设置->高级权限系统前打勾，确定即可。
```

### 如何限制游客进入大厅以外的频道？

```
首先启用“高级权限系统”
点击权限->服务器组，选取游客->频道->访问->进入频道权力(i_channel_join_power)的值设为-1
```

### 设置频道为强制按键通话模式

```
首先启用“高级权限系统”
点击权限->频道，选择要设置的频道，右侧权限列表中选择用户->修改->强制按键通话，打勾选中，确定即可。
此时进入频道的所有用户都必须要设置为“按键激活”模式才能发言，“语音感应”激活麦克风方式将不能发言。
```