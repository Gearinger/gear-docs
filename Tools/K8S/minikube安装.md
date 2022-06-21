## 一、kubectl

### 1、修改yum 仓库

```sh
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

### 2、安装kubectl

```sh
yum install -y kubectl
```

### 3、检查

```sh
kubectl version
```

## 二、docker

### 1、卸载旧版本

```sh
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

### 2、安装基础包

```sh
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

### 3、设置仓库

```sh
yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

### 4、安装docker

```sh
yum install docker-ce docker-ce-cli containerd.io
```

> 如果失败，按照错误提醒进行配置。错误实在无法解决时，请指定版本
> 
> ```sh
> yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
> ```

### 5、启动

```sh
systemctl start docker
```

## 三、minikube

### 1、获取安装包

[官网安装教程](https://minikube.sigs.k8s.io/docs/start/)

```shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

### 2、安装

```sh
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### 3、启动

```shell
minikube start --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers
```

> （1）虚拟机需指定driver（也可不指定driver为none，直接安装virtual-box）
> 
> ```sh
> minikube start --vm-driver=none --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers
> ```
> 
> （2）如果提示conntrack被kubernetes依赖，安装下即可
> 
> ```sh
> yum install epel-release
> yum install conntrack-tools
> ```