## 一、作用

- 静态资源服务

- http/https 代理

- stream 代理

- 负载均衡

---

## 二、常用命令

```shell
# 启动
nginx
# 停止
nginx -s stop 
# 安全退出
nginx -s quit
# 重新加载配置文件
nginx -s reload
```

## 三、基础配置

```nginx
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    # 负载均衡
    upstream testsite {
        server 127.0.0.1:8000;
        server 127.0.0.1:8001;
    }

    server {
        listen       80;
        server_name  localhost;

        # 注意："\"会和字母形成转义符，只能用 "\\" 或者 "/" 代表路径层级的分隔符

        # 反向代理
        location /testproxy/ {
            # proxy_pass 最后带斜杠，则将 location 完全替换为 proxy_pass
            proxy_pass http://127.0.0.1:8080/;

            # proxy_pass 最后不带斜杠，则将 location 和 proxy_pass 进行拼接
            # proxy_pass http://127.0.0.1:8080;

            # 注： 反向代理中可以添加重定向去做动静分离
        }

        # 静态文件代理
        location /test/ {
            # 文件的路径会拼接 location，下面的会变成 D:/Tools/nginx/conf/test/
            # root D:/Tools/nginx/conf/;      

            # alias 的路径便是文件路径
            alias D:/Tools/nginx/conf;    

            # 一般设置需要 location 和 alias 都带斜杠或都不带
        }

        # 对应负载均衡的反向代理，这里 proxy_pass 的 testsite 与 upstream 的 testsite 保持一致
        location /test2/ {
            proxy_pass http://testsite/;
        }

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```

## 四、Stream代理

### 1、流量代理

```nginx
# 代理127.0.0.1的3389端口到7000端口（可用于代理远程桌面）
server{
    listen 7000;
    proxy_pass 127.0.0.1:3389;
}
```

### 2、负载均衡

只列出了常用的轮询、权重、ip哈希三种方式，另外还有最少连接、随机、加权随机等。

注：配置放在根节点，与server一级

```nginx
# 轮询法
upstream gear-server {
    server 127.0.0.1:9001;    
    servr 127.0.0.1:9002;
}

# 权重法
upstream gear-server {
    server 127.0.0.1:9001 weight=1;
    server 127.0.0.1:9002 weight=2;
    server 127.0.0.1:9003 weight=1;
}

# ip哈希（会根据ip绑定访问同一服务器），比权重法多了个ip_hash
upstream gear-server {
    ip_hash;
    server 127.0.0.1:9001 weight=1;
    server 127.0.0.1:9002 weight=2;
    server 127.0.0.1:9003 weight=1;
}
```

# 五、Https配置（自定义证书）

OpenSSL下载：[/source/index.html (openssl.org)](https://www.openssl.org/source/)

> 官网不提供 windows 版本下载。可搜索第三方提供的。此处采用的是 git 自带的（路径：[C:\Program Files\Git\mingw64\bin](https://github.com/Gearinger/gear-docs/blob/master/Tools/Nginx)）

（1）生成 `RSA` 秘钥

```shell
#实际使用中看服务器性能，如果足够好也可以使用4096位秘钥
openssl genrsa -out nginx.pem 1024  
```

（2）生成证书请求

```shell
# 注意，Common Name 应当填写你要部署的域名，或使用*，对所有mydomain.com的子域名做认证
openssl req -new -key nginx.pem -out nginx.csr
```

（3）签发证书

```shell
openssl x509 -req -days 36500 -in nginx.csr  -signkey nginx.pem -out nginx.crt
```

（4）配置 `nginx`

> `nginx` 一般都自带有 `ssl` 的支持

```shell
# 在 server 节点添加如下内容
server {    ...    listen       443 ssl;
    server_name  test.mydomain.com;   #与申请时的域名保持一致，否则会报错

    ssl_certificate "/etc/nginx/ssl/nginx.crt";   #
    ssl_certificate_key "/etc/nginx/ssl/nginx.pem";
    ssl_session_cache shared:SSL:1m;
    ssl_session_timeout  10m;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    ...}
```

（5）重新载入 `nginx`

```shell
nginx -s reload
```
