

~~~shell
docker pull redis

docker network create --subnet 172.18.0.0/24 redis-net

mkdir -p /home/redis-cluster
cd /home/redis-cluster

for port in $(seq 8010 8015); \
do \
  mkdir -p ./${port}/conf
  mkdir -p ./${port}/data
  touch ./${port}/conf/redis.conf
  cat EOF ./${port}/conf/redis.conf
  port ${port}
  cluster-enabled yes
  cluster-config-file nodes.conf
  cluster-node-timeout 5000
  cluster-announce-ip 192.168.168.131
  cluster-announce-port ${port}
  cluster-announce-bus-port 1${port}
  appendonly yes
  EOF
done


for port in $(seq 8010 8015); \
do \
   docker run -it -d -p ${port}:${port} -p 1${port}:1${port} \
  --privileged=true -v /home/redis-cluster/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf \
  --privileged=true -v /home/redis-cluster/${port}/data:/data \
  --restart always --name redis-${port} --net redis-net \
  --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf; \
done

docker exec -it redis-8010 bash

cd /usr/local/bin/

redis-cli --cluster create 192.168.168.131:8010 192.168.168.131:8011 192.168.168.131:8012 192.168.168.131:8013 192.168.168.131:8014 192.168.168.131:8015

~~~

参考：https://blog.csdn.net/l1028386804/article/details/105681536