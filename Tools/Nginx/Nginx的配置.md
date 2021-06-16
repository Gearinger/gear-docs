Nginx 的基础配置说明

~~~sh

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
            # root 会拼接 location
            root D:/Tools/nginx/conf/;      

            # alias 完全替换 location
            # http://127.0.0.1/test/1.txt 会被替换为  D:/Tools/nginx/conf1.txt
            # 所以一般设置需要 location 和 alias 都带斜杠或都不带
            # alias D:/Tools/nginx/conf;    
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
~~~

