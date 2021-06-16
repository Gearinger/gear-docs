set -e

docker pull redis

docker network create --subnet 172.10.0.0/24 redis-net

mkdir -p /data/docker/redis/cluster
cd /data/docker/redis/cluster

echo '请输入本机的IP地址：'
read ip

for port in $(seq 8010 8015); do
  mkdir -p ./${port}/conf
  mkdir -p ./${port}/data
  touch ./${port}/conf/redis.conf
  cat>./${port}/conf/redis.conf<<EOF
  port ${port}
  cluster-enabled yes
  cluster-config-file nodes.conf
  cluster-node-timeout 5000
  cluster-announce-ip ${ip}
  cluster-announce-port ${port}
  cluster-announce-bus-port 1${port}
  appendonly yes
EOF
done

for port in $(seq 8010 8015); do 
   docker run -it -d -p ${port}:${port} -p 1${port}:1${port} \
  --privileged=true -v /data/docker/redis/cluster/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf \
  --privileged=true -v /data/docker/redis/cluster/${port}/data:/data \
  --restart always --name redis-${port} --net redis-net \
  --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf; \
done

docker exec -it redis-8010 /bin/sh -c "cd /usr/local/bin/;redis-cli --cluster create ${ip}:8010 ${ip}:8011 ${ip}:8012 ${ip}:8013 ${ip}:8014 ${ip}:8015 --cluster-replicas 1"

