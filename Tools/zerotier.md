# 自建`Zerotier`服务器

## 一、概述

### 1、作用

异地组建局域网

### 2、原理

利用P2P针对“客户端A”和“客户端B”建立通讯隧道，但是服务器只承担类似于DNS解析的作用，实际AB间传输的数据不经过服务器

### 3、问题及解决方式

`Zerotier`官方服务器在海外，存在高延迟和丢包。官方有提供自建`Moon`服务器（相当于自建服务器接入官方服务器）的方式，但对于墙内来说也完全不适用。

此处利用开源工具自建`Zerotier`服务器，但实际效果依旧不理想。

### 4、测试及结果

>服务器：腾讯云 2核2G 4Mbps
>
>客户端A：Win10 200Mbps 广电网
>
>客户端B：Android 联通4G
>
>测试结果：
>
>- ping
>
>  450ms
>
>- 带宽
>
>  同一局域网：3~4m/s
>
>  非相同局域网：70k/s
>
>- 丢包
>
>  30% 经常连接失败

## 二、自建`Zerotier`服务器

参考：[一分钟自建zerotier-plant - Jonnyan的原创笔记 - 亖亖亖 (mrdoc.fun)](https://www.mrdoc.fun/doc/443/)

### 1、服务端安装

服务器安装`docker` 和 `docker-compose`

~~~sh
cd /data/docker/zerotier
vim docker-compose.yml
~~~

~~~yaml
### date:2021年11月29日
### author: www.mrdoc.fun | jonnyan404
### 转载请保留来源
version: '2.0'
services:
    ztncui:
        container_name: ztncui
        restart: always
        environment:
            # - MYADDR=公网地址(不填自动获取)
            - HTTP_PORT=4000
            - HTTP_ALL_INTERFACES=yes
            - ZTNCUI_PASSWD=mrdoc.fun
        ports:
            - '4000:4000'
           # - '3180:3180'具体参考GitHub项目说明
        image: keynetworks/ztncui
~~~

~~~sh
docker-compose up -d
~~~

访问`Zerotier`网络管理页面：`服务器IP:4000`

账号密码：admin/mrdoc.fun

### 2、新建网络

![image-20220425163101738](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220425-163103.png)

![image-20220425163127654](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220425-163129.png)

点击“easy setup”-“Generate network address”生成网络地址，并点击submit提交

![image-20220425163231900](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220425-163233.png)

### 3、客户端加入网络

下载`Zerotier`：[Download – ZeroTier](https://www.zerotier.com/download/)

添加上一步创建的网络ID

![image-20220425163352912](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220425-163354.png)

客户端配置勾选（无该界面可跳过）

![image-20220425163441360](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220425-163442.png)

### 4、授权客户端

访问`Zerotier`网络管理页面：`服务器IP:4000`，给客户端添加授权

![image-20220425163650290](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220425-163651.png)

至此完成！