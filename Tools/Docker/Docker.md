## Docker是什么

​		Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的[镜像](https://baike.baidu.com/item/镜像/1574)中，然后发布到任何流行的 [Linux](https://baike.baidu.com/item/Linux)或[Windows](https://baike.baidu.com/item/Windows/165458)操作系统的机器上，也可以实现[虚拟化](https://baike.baidu.com/item/虚拟化/547949)。容器是完全使用[沙箱](https://baike.baidu.com/item/沙箱/393318)机制，相互之间不会有任何接口。

​		Docker相当于更高效的虚拟机。

[Docker 文档 | Docker Documentation](https://docs.docker.com/)

## Docker安装

[Install Docker Engine | Docker Documentation](https://docs.docker.com/engine/install/)

### 示例 `Centos` 安装 `Docker`:

#### 1、卸载旧版本

~~~sh
sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine
~~~

#### 2、安装环境

~~~sh
yum install -y yum-utils
~~~

#### 3、设置镜像仓库

~~~sh
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo  #官网镜像
    
    # 设置阿里云的Docker镜像仓库
yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo  #阿里镜像
~~~

#### 4、安装新版本

（docker-ce 是社区版，docker-ee 企业版）

~~~sh
yum install docker-ce docker-ce-cli containerd.io
~~~

#### 5、启动

~~~sh
systemctl start docker

# 查看当前版本号，是否启动成功
docker version

# 设置开机自启动
systemctl enable docker
~~~

#### 6、Docker的卸载

```bash
# 1. 卸载依赖
yum remove docker-ce docker-ce-cli containerd.io
# 2. 删除资源  . /var/lib/docker是docker的默认工作路径
rm -rf /var/lib/docker
```

#### 7、配置阿里云镜像加速

[容器镜像服务 (aliyun.com)](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)

##### 1. 安装／升级Docker客户端

推荐安装1.10.0以上版本的Docker客户端，参考文档[docker-ce](https://yq.aliyun.com/articles/110806)

##### 2. 配置镜像加速器

针对Docker客户端版本大于 1.10.0 的用户

您可以通过修改daemon配置文件/etc/docker/daemon.json来使用加速器

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://uixmgy2z.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 网络

> 网络模式：桥接（bridge）、none、host（与主机用同一个ip，每个端口只能被使用一次）、container（容器内网络联通）

~~~sh
docker network --help

# 列出所有网络
docker network ls

# 创建 bridge 模式、子网为192.168.0.0/16、网关为192.168.0.1 的 docker网络
docker network create --driver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 testnet

# 使用自定义的网络运行容器
docker run -P -net testnet --name "mysql" -d mysql
~~~

## 常用命令

> 命令中的容器id可只拼写前几位，保证不与其他容器id重复即可。

~~~sh
# 拉取镜像
docker pull mysql
# 拉取指定版本镜像
docker pull mysql:5.7

# 运行镜像
docker run -d -v 宿主机路径:容器内路径 -p 宿主机端口:容器端口 --name="mysql" 镜像名/id

~~~

- 容器

~~~sh
# 查看容器
docker ps

# 启动容器
docker start 

# 重启容器
docker restart

# 停止容器
docker stop

# 移除容器
docker rm
~~~

- 镜像

~~~sh
# 查看容器相关命令
docker images --help

# 查看镜像信息
docker images

# 查看所有镜像信息
docker images -a

# 查看镜像的ID
docker images -q

# 移除镜像
docker rmi
~~~

- 其他

~~~sh
# 从dockerfile构建镜像
docker build

# 从容器构建镜像
docker commit

# 从dockerhub搜索镜像
docker search

# 进入运行中的容器
docker run -it centos /bin/bash

# 查看日志
docker logs 容器名称/id
# 将日志信息复制到log.log文件
docker logs 容器名称/id >> log.log	

# 查看容器信息
docker inspect 容器ID

#拷贝容器的文件到主机中
docker cp 容器id:容器内路径  目的主机路径

#拷贝宿主机的文件到容器中
docker cp 目的主机路径 容器id:容器内路径
~~~

