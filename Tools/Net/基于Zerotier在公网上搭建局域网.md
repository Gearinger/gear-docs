# 无公网IP通过ZeroTier方便实现内网穿透

### ZeroTier原理：

> ZeroTier虚拟了一个网段，网段为192.168.196.0/24，公司和家里分别安装ZeroTier客户端，客户端会虚拟出一个网络并加入192.168.196.0/24这个网段，在家即可访问192.168.196.216地址，反之同理。

![img](https://upload-images.jianshu.io/upload_images/14270006-5deb2bda7c9eb193.png?imageMogr2/auto-orient/strip|imageView2/2/w/554/format/webp)

ZeroTier原理

### [ZeroTier官网](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.zerotier.com%2F)

![img](https://upload-images.jianshu.io/upload_images/14270006-a66461354f6d7738.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### [客户端工具下载地址](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.zerotier.com%2Fdownload%2F)



![img](https://upload-images.jianshu.io/upload_images/14270006-dddb640fabab3202.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


**提供Windows，Linux，Mac等客户端**



### [注册账户](https://links.jianshu.com/go?to=https%3A%2F%2Fmy.zerotier.com%2Flogin)

![img](https://upload-images.jianshu.io/upload_images/14270006-3b9fd86cbc940213.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### [创建network](https://links.jianshu.com/go?to=https%3A%2F%2Fmy.zerotier.com%2Fnetwork)

![img](https://upload-images.jianshu.io/upload_images/14270006-8296d8d775f03b4d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

### [Linux服务器上安装](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.zerotier.com%2Fdownload%2F)



```shell
curl -s https://install.zerotier.com | sudo bash
```



```linux
curl -s 'https://raw.githubusercontent.com/zerotier/download.zerotier.com/master/htdocs/contact%40zerotier.com.gpg' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
```

##### 1. 通过客户端工具，添加上述的网络Id，这样就加入了这个虚拟的内网环境。



```shell
$ zerotier-one -d    #启动zerotier
$ zerotier-cli info    #查看zerotier信息
```



![img](https://upload-images.jianshu.io/upload_images/14270006-8a234d60bba9f77d.png?imageMogr2/auto-orient/strip|imageView2/2/w/334/format/webp)

200表示成功


**`ID`是你自己创建的`network ID`**





```shell
$ zerotier-cli join Network ID  #ID是你自己创建的network ID
```

**加入后会提示`200 join OK`**

![img](https://upload-images.jianshu.io/upload_images/14270006-17e067ed7f0003f4.png?imageMogr2/auto-orient/strip|imageView2/2/w/487/format/webp)


**win10客户端也加入进去**

![img](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-124905)



##### 2. 添加好后，需要在下面的网站，将增加的客户端授权。

**[https://my.zerotier.com/network/ID](https://links.jianshu.com/go?to=https%3A%2F%2Fmy.zerotier.com%2Fnetwork%2FID)此处ID为自己创建的network ID**

**授权主要是选择checkbox，稍后就会拿到**

![img](https://upload-images.jianshu.io/upload_images/14270006-cdd5cf62001face5.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



**分配Manage IPs（192.168.196.XX）**

![img](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-124904)



### 3.主机验证

**回到centos7主机上通过`ifconfig`命令即可看到，此处又多了一个内网IP，此内网IP和zerotier一致，表示配置完成**

![img](https://upload-images.jianshu.io/upload_images/14270006-8cde217559efe8f4.png?imageMogr2/auto-orient/strip|imageView2/2/w/660/format/webp)



### 4.局域网访问测试

**我在`192.168.196.216`服务器上启动一个占用端口`8001`的`WebServer`，在`192.168.196.249`电脑上通过`Postman`访问这个`WebServer`**

![img](https://upload-images.jianshu.io/upload_images/14270006-704ed6f835f44a6f.png?imageMogr2/auto-orient/strip|imageView2/2/w/1047/format/webp)



### 加入、离开、列出网络状态命令



```shell
$ zerotier-cli join Network ID
$ zerotier-cli leave Network ID
$ zerotier-cli listnetworks
```