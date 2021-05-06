### docker-compose

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











