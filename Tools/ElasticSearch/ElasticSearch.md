### 1、安装

[Getting started with the Elastic Stack | Getting Started 8.1 | Elastic](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-elastic-stack.html)

#### （1）`Docker` 环境安装

[Running the Elastic Stack ("ELK") on Docker | Getting Started 8.1 | Elastic](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-stack-docker.html)

~~~sh
# 拉取 ES 镜像
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.1.0
# 创建自定义网络
docker network create elastic
# 运行 ES 实例
docker run --name es01 --net elastic -p 9200:9200 -it docker.elastic.co/elasticsearch/elasticsearch:8.1.0

# 拉取 kibana 镜像
docker pull docker.elastic.co/kibana/kibana:8.1.0
# 运行 kibana 实例
docker run --name kibana --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.1.0
~~~

> 注意：ES 运行成功时显示的秘钥信息需要保存，供后续使用
>
> windows环境下需扩展内存：
>
> ~~~sh
> wsl -d docker-desktop
> sysctl -w vm.max_map_count=262144
> exit
> ~~~

#### （2）`Linux` 环境安装

#### （3）`Windows` 环境安装

### 2、使用

#### （1）简要了解

~~~sh
# 自动创建索引
POST /gear_test/_doc
{
  "name":"test"
}

# 搜索索引下所有记录
GET /gear_test/_search

# 删除索引
DELETE /gear_test
~~~

#### （2）所有DSL简要使用

~~~sh
# 创建索引
PUT /customer?pretty

# 获取所有索引
GET /_cat/indices?

# 查看索引信息
GET /customer

# 新增记录，id自动赋值
POST /customer/_doc
{
  "name": "Tom"
}

# 指定id,新增/更新记录
POST /customer/_doc/1
{
  "name":"Jsck"
}

# 指定id,新增/更新记录
PUT /customer/_doc/1
{
  "name":"Jerry"
}

# 获取所有记录
GET /customer/_search

DELETE /customer
~~~

#### （3）GET 详解

> ES是使用分词器对字符串进行拆分后，再创建倒排索引的。非拆分字符，是搜索不到相应内容的。eg："Jac"无法搜索到"Jack like the chair."

~~~sh
# 从所有索引里查询
GET _search
{   
  "query": {
    # 所有匹配的值
    "match_all": {}

    # item 精确查询 相等
    "term": {
      "phone": "12345678909"
    }
    # items
    "terms": {
      "uid": [ 
        1234, 
        12345, 
        123456
      ] 
    }

	# range 字段值是否在某个范围
    "range": { 
      "uid": { 
        "gt": 1234,
        "lte": 12345
      } 
    } 
	
	# exists 字段是否存在
    "exists": { 
      "field":"msgcode" 
    } 
    
    # bool 合并多个过滤条件
    "bool": {
      "must": {
        "term": {
          "phone": "12345678909"
        }
      },
      "must_not": {
        "term": {
          "uid": 12345
        }
      },
      "should": [
        {
          "term": {
            "uid": 1234
          }
        },
        {
          "term": {
            "uid": 123456
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
    
	# wildcard 类似于SQL的like查询
	"wildcard": { 
       "message":"*wu*" 
    } 
    
    # regexp 正则查询
    "regexp": { 
       "message":"xu[0-9]" 
    } 
    
    # match 全文检索，使用ik_smart将"超级羽绒服"分词，再用分词结果到es中查询包含"超级"、"羽绒"、"羽绒服"（具体分词根据分词器变化）等分词的记录，进行评分排序输出。不指定分词器时采用默认分词器。
    "match": {
      "name": {
        "query": "超级羽绒服",
        "analyzer": "ik_smart"
      }
    }
    
    # match_phrase 不采用分词器，直接查找包含对应短语的记录
    # 与match的区别：match采用分词器，match_phrase不采用分词器
    "match_phrase": { 
      "address": "mill lane" 
    } 
  }
}
~~~

​	

### 3、其他

#### （1）空间数据

[Geoshape field type | Elasticsearch Guide [8.1\] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/8.1/geo-shape.html)

> ES针对空间数据包含两种字段类型：geo_point、geo_shape

~~~sh
# 创建索引，指定字段类型
PUT /example
{
  "mappings": {
    "properties": {
      "location": {
        "type": "geo_shape"
      }
    }
  }
}

# 新增数据
POST /example/_doc?refresh
{
  "name": "Wind & Wetter, Berlin, Germany",
  "location": {
    "type": "point",
    "coordinates": [ 13.400544, 52.530286 ]
  }
}

# 查询数据
GET /example/_search

# 删除索引
DELETE /example
~~~

##### geometry 插入

- geojson 格式插入

~~~sh
# 新增数据
PUT /example/_doc?refresh
{
  "name": "Wind & Wetter, Berlin, Germany",
  "location": {
    "type": "point",
    "coordinates": [ 13.400544, 52.530286 ]
  }
}
~~~

- wkt 格式插入

~~~sh
# 新增数据
PUT /example/_doc?refresh
{
  "name": "Wind & Wetter, Berlin, Germany",
  "location": "POINT (13.400544 52.530286)"
}
~~~



### 4、Issue

#### （1）关于 ES 的 http、https

docker安装ES默认采用https访问，访问地址：https://127.0.0.1:9200

**http 不可访问**，第三方数据库连接工具也需要用 https

- 关于 Java 的 client 连接

> **官方推荐使用**：[Elasticsearch Java API Client | Elastic](https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/index.html)
>
> 以下已弃用（只维护到7.17版本）
>
> [Java REST Client | Elastic](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/current/index.html)
>
> [Java High Level REST Client | Java REST Client | Elastic](https://www.elastic.co/guide/en/elasticsearch/client/java-rest/current/java-rest-high.html)
>
> [Java Transport Client (deprecated) | Elastic](https://www.elastic.co/guide/en/elasticsearch/client/java-api/current/index.html)
>
> Spring 官方维护的 Spring Data ES 也被弃用

~~~java
// 通过https连接ES，不验证客户端证书
final CredentialsProvider credentialsProvider =
  new BasicCredentialsProvider();
credentialsProvider.setCredentials(AuthScope.ANY,
                                   new UsernamePasswordCredentials("elastic", "nCxouQfpOcxxBMBxX2+7"));

SSLContext sslContext = new SSLContextBuilder().loadTrustMaterial(null, new TrustStrategy() {
  @Override
  public boolean isTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
    return true;
  }
}).build();

RestClientBuilder builder = RestClient.builder(
  new HttpHost("localhost", 9200, "https"))
  .setHttpClientConfigCallback(new RestClientBuilder.HttpClientConfigCallback() {
    @Override
    public HttpAsyncClientBuilder customizeHttpClient(
      HttpAsyncClientBuilder httpClientBuilder) {
      httpClientBuilder.setSSLContext(sslContext);
      httpClientBuilder.setDefaultCredentialsProvider(credentialsProvider);
      return httpClientBuilder;
    }
  });
RestClient restClient = builder.build();
ElasticsearchTransport transport = new RestClientTransport(
  restClient, new JacksonJsonpMapper());
ElasticsearchClient client = new ElasticsearchClient(transport);
BooleanResponse ping = client.ping();
System.out.println(ping);
restClient.close();
~~~

#### （2）关于推荐的 Java SDK

**从 8.0 版本开始，官方推荐使用**：[Elasticsearch Java API Client | Elastic](https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/index.html)

#### （3）关于不同的 client 连接方式（JAVA）

- http 连接

~~~java
// Create the low-level client
RestClient restClient = RestClient.builder(
    new HttpHost("localhost", 9200)).build();

// Create the transport with a Jackson mapper
ElasticsearchTransport transport = new RestClientTransport(
    restClient, new JacksonJsonpMapper());

// And create the API client
ElasticsearchClient client = new ElasticsearchClient(transport);
~~~

- http 密码连接

~~~java
final CredentialsProvider credentialsProvider =
    new BasicCredentialsProvider();
credentialsProvider.setCredentials(AuthScope.ANY,
    new UsernamePasswordCredentials("user", "test-user-password"));

RestClientBuilder builder = RestClient.builder(
    new HttpHost("localhost", 9200))
    .setHttpClientConfigCallback(new HttpClientConfigCallback() {
        @Override
        public HttpAsyncClientBuilder customizeHttpClient(
                HttpAsyncClientBuilder httpClientBuilder) {
            return httpClientBuilder
                .setDefaultCredentialsProvider(credentialsProvider);
        }
    });
~~~

- http token/API key 连接

[Other authentication methods | Elasticsearch Java API Client 8.1| Elastic](https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/_other_authentication_methods.html)

- https 客户端证书连接

[Encrypted communication | Elasticsearch Java API Clien | Elastic](https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/_encrypted_communication.html)

- https 密码连接

见：**（1）关于 ES 的 http、https**