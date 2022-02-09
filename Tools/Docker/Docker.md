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

## Docker-Compose

> docker-compose 文件内容规则

~~~
build：构建镜像上下文路径
dockerfile：指定dockerfile文件名
image：来自镜像
args：构建参数，在dockerfile中指定的参数
command：覆盖默认命令
container_name：自定义容器名称。如果自定义名称，则无法将服务scale到1容器之外
deploy：指定与部署和运行相关的配置。限版本3
depends_on：服务之间的依赖，控制服务启动顺序，正常是按顺序启动服务
dns：自定义DNS服务器，可以是单个值或列表
entrypoint：覆盖entrypoint
env_file：从文件添加环境变量，可以是单个值或列表
environment：添加环境变量，可以是数组或字典，布尔值用引号括起来
expose：声明容器服务端口
links：连接到另一个容器
external_links：连接Compose之外的容器
extra_hosts：添加主机名映射，与--add-host相同
logging：记录该服务的日志，与--log-driver相同
network_mode：网络模式，与--net相同
networks：要加入的网络
pid：将PID模式设置主机PID模式，与宿主机共享PID地址空间，如pid: "host"
ports：暴露端口，与-p相同，但端口不低于60
sysctls：在容器内设置内核参数，可以是数组或字典
ulimits：覆盖容器的默认ulimits
volumes：挂载一个目录或一个已存在的数据卷容器到容器
restart：默认no，可选参数always|on-failure|unless-stopped
hostname：主机名
working_dir：工作目录
~~~

---

> docker-compose.yml示例文件

~~~yaml
version: '3.4'
services:
  django-web:
    image: python_django:19.03.0
    ports:
      - 8000:8000
    command:
      - /bin/bash 
      - -c 
      - |
        cd /app01 
        python manage.py runserver 0.0.0.0:8000
    volumes:
      - /app01:/app01
~~~



~~~yaml
# minio
version: 3
services:
  minio:
    image: minio/minio
    ports:
      - 9000:9000
    volumes:
      - /data/docker/minio:/data
      - /data/docker/minio/config:/root/.minio
~~~



~~~yaml
# mysql
version: 3
services:
  mysql:
    image: mysql
    ports:
      - 3306:3306
    volumes:
      - /data/docker/minio:/data
      - /data/docker/minio/config:/root/.minio
~~~

---

## Docker & MiniKube

1、安装 docker

[Explore Docker's Container Image Repository | Docker Hub](https://hub.docker.com/search?q=&type=edition&offering=community&sort=updated_at&order=desc)

2、配置 docker 远程仓库（提供镜像给k8s使用）

（1）配置

~~~sh
docker pull registry
docker run -d -p 5000:5000 --name registry registry

docker pull hyper/docker-registry-web
docker run -d -p 5001:8080 --name registry-web --link registry -e REGISTRY_URL=http://registry:5000/v2 -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web

~~~

（2）推送远程仓库镜像

~~~sh
# 从dockerhub获取镜像
docker pull hello-world
# 重命名镜像（格式：必须在/前包含远程仓库地址，不然无法推送）
docker tag hello-world localhost:5000/zyj-test:1.0

# 将镜像推送到远程仓库
docker push localhost:5000/zyj/test:1.0
~~~

（3）拉取远程仓库镜像

~~~sh
# 从远程仓库拉取镜像
docker pull localhost:5000/zyj/test:1.0
~~~

3、安装 minikube

[minikube start | minikube (k8s.io)](https://minikube.sigs.k8s.io/docs/start/)

4、minikube 创建 deployment （使用私有仓库的镜像）



5、minikube 常用命令



> 远程仓库地址：127.0.0.1:5000
>
> 远程仓库web端：[Web Registry - Repositories](http://127.0.0.1:5001/)
>
> 