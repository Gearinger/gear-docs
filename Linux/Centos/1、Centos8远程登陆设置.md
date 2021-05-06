### ssh公钥登陆设置

1. 客户端本地生成密钥对（包括公钥.pub和私钥）
2. 将公钥配置到服务器端/root/.ssh/authorized_keys文件中



### ssh配置文件路径

/etc/ssh/sshd_config



### ssh配置内容

- 端口配置

![image-20200608190838761](C:\Users\Gear\AppData\Roaming\Typora\typora-user-images\image-20200608190838761.png)

- 允许root账户登录

  ![image-20200608191219774](C:\Users\Gear\AppData\Roaming\Typora\typora-user-images\image-20200608191219774.png)

- 允许密钥登陆

  ![image-20200608191317366](C:\Users\Gear\AppData\Roaming\Typora\typora-user-images\image-20200608191317366.png)

- 禁止密码登录

![](C:\Users\Gear\AppData\Roaming\Typora\typora-user-images\image-20200608191247254.png)

- 重启ssh

  ~~~shell
  service sshd restart
  ~~~

  