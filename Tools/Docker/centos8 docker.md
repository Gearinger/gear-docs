## Centos8 对应的 Docker 需安装 Containerd.io-1.2.6

> 错误如下：
>
> ~~~sh
> journalctl -xe
> ~~~
>
> ~~~sh
> Nov 15 11:38:23 instance-5p54s4tz containerd[1608]: /usr/bin/containerd: symbol lookup error: /usr/bin/containerd: undefined symbol: seccomp_api_set
> Nov 15 11:38:23 instance-5p54s4tz systemd[1]: containerd.service: Main process exited, code=exited, status=127/n/a
> Nov 15 11:38:23 instance-5p54s4tz systemd[1]: containerd.service: Failed with result 'exit-code'.
> Nov 15 11:38:23 instance-5p54s4tz systemd[1]: Failed to start containerd container runtime.
> ~~~

~~~sh
# 下载docker-ce的repo
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo

# 安装依赖
yum install https://download.docker.com/linux/fedora/30/x86_64/stable/Packages/containerd.io-1.2.6-3.3.fc30.x86_64.rpm

# 安装docker-ce
yum install docker-ce -y

# 启动docker
systemctl start docker

~~~

