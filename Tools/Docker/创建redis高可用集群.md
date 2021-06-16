sh脚本

~~~sh
docker network create redis --subnet 192.38.0.0/16

# 创建配置文件
for num in $(seq 1 6)
do \
mkdir -p /data/docker/redis/node-${num}/conf
touch /data/docker/redis/node-${num}/conf/redis.conf
cat << EOF > /data/docker/redis/node-${num}/conf/redis.conf
port 6379
bind 0.0.0.0
cluster enabled yes
cluster node timeout 5000
cluster-announce-ip 172.38.0.1${num}
cluster-announce-port 6379
cluster-announce-bus-port 16379
appendonly yes
EOF
done

# 运行 docker 容器
for port in $(seq 11 16)
do \
docker run -d -p 
~~~

