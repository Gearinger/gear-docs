### 自定义证书 HTTPS 配置

OpenSSL下载：[/source/index.html (openssl.org)](https://www.openssl.org/source/)

> 官网不提供 windows 版本下载。可搜索第三方提供的。此处采用的是 git 自带的（路径：[C:\Program Files\Git\mingw64\bin]()）

（1）生成 `RSA` 秘钥

~~~sh
#实际使用中看服务器性能，如果足够好也可以使用4096位秘钥
openssl genrsa -out nginx.pem 1024  
~~~

（2）生成证书请求

~~~sh
# 注意，Common Name 应当填写你要部署的域名，或使用*，对所有mydomain.com的子域名做认证
openssl req -new -key nginx.pem -out nginx.csr
~~~

（3）签发证书

~~~sh
openssl x509 -req -days 36500 -in nginx.csr  -signkey nginx.pem -out nginx.crt
~~~

（4）配置 `nginx`

> `nginx` 一般都自带有 `ssl` 的支持

~~~sh
# 在 server 节点添加如下内容
server {
	...
	
    listen       443 ssl;
    server_name  test.mydomain.com;   #与申请时的域名保持一致，否则会报错

    ssl_certificate "/etc/nginx/ssl/nginx.crt";   #
    ssl_certificate_key "/etc/nginx/ssl/nginx.pem";
    ssl_session_cache shared:SSL:1m;
    ssl_session_timeout  10m;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
	...
}
~~~

（5）重新载入 `nginx` 

~~~sh
nginx -s reload
~~~

