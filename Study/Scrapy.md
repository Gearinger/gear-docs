# Scrapy

[Scrapy | A Fast and Powerful Scraping and Web Crawling Framework](https://scrapy.org/)

[Scrapy project (github.com)](https://github.com/scrapy)

## 一、概览

![img](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211009-1702.top&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

​		Scrapy主要分为五个部分，调度队列Scheduler、请求工具Downloader、爬取数据工具Spider、数据队列（数据遍历输出端）Pipiline、Scrapy封装引擎ScrapyEngine。另外还有部分中间件。

​		但是，主要使用的是Spiders和Pipeline。Spiders包含多个爬虫，每个爬虫中内容包括定义爬虫名、定义起始页、爬取的所在域名、解析网页的信息、yield数据到队列。

​		Pipeline遍历所有爬虫yield的数据，对其进行进一步清洗和入库。

​		中间件现已有大量网友编写的，也可自定义中间件。针对数据的流转进行过滤、修改、切片等处理。

## 二、快速开始

### 1、创建项目

```sh
scrapy startproject tutorial
```

> 目录结构
>
> ```
> tutorial/
>  scrapy.cfg            # deploy configuration file
>  tutorial/             # project's Python module, you'll import your code from here
>      __init__.py
>      items.py          # project items definition file
>      middlewares.py    # project middlewares file
>      pipelines.py      # project pipelines file
>      settings.py       # project settings file
>      spiders/          # a directory where you'll later put your spiders
>          __init__.py
> ```

### 2、创建爬虫

~~~sh
scrapy genspider baidu "baidu.com"
~~~

> 爬虫内容：
>
> ```python
> import scrapy
> 
> 
> class QuotesSpider(scrapy.Spider):
>  name = "quotes"
>  allowed_domains = ["baidu.com"]
>  start_urls = [  # 开始爬取的链接
>      'https://www.baidu.com/'
>  	 ]
> 
> def parse(self, response):
>     filename = 'baidu.com.txt'
>     with open(filename, 'wb') as f:
>         f.write(response.body)
>         self.log(f'Saved file {filename}')
> ```

### 3、运行爬虫

```sh
scrapy crawl quotes
```

## 三、详细情况

### 1、spider

#### （1）实现 spider 的几种方式

- 基本爬虫 scrapy.Spider

> 仅对起始页进行解析
>
> ```python
> import scrapy
> 
> class NovelSpider(scrapy.Spider):  # 继承Spider类
>     name = "novel_spider2"
>     allowed_domains = ["biquduu.com"]
>     start_urls = [  # 开始爬取的链接
>         "https://www.biquduu.com/"
>     ]
> 
>     def parse(self, response):
>         pass
> ```

- 进一步封装的爬虫 CrawlSpider, SitemapSpider, CSVFeedSpider, XMLFeedSpider

  - CrawlSpider

  > crawlspider是Spider的派生类(一个子类)，Spider类的设计原则是只爬取start_url列表中的网页，而CrawlSpider类定义了一些规则(rule)来提供跟进link的方便的机制，从爬取的网页中获取link并继续爬取的工作更适合。
  >
  > ```python
  > from scrapy.spiders import CrawlSpider
  > 
  > # 表示该爬虫程序是基于CrawlSpider类的
  > class CrawldemoSpider(CrawlSpider):
  >     name = 'crawlDemo'    #爬虫文件名称
  >     #allowed_domains = ['www.qiushibaike.com']
  >     start_urls = ['http://www.qiushibaike.com/']
  >     
  >     #连接提取器：会去起始url响应回来的页面中提取指定的url
  >     link = LinkExtractor(allow=r'/8hr/page/\d+')
  >     #rules元组中存放的是不同的规则解析器（封装好了某种解析规则)
  >     rules = (
  >         #规则解析器：可以将连接提取器提取到的所有连接表示的页面进行指定规则（回调函数）的解析
  >         Rule(link, callback='parse_item', follow=True),
  >     )
  >     # 解析方法
  >     def parse_item(self, response):
  >         #print(response.url)
  >         divs = response.xpath('//div[@id="content-left"]/div')
  >         for div in divs:
  >             author = div.xpath('./div[@class="author clearfix"]/a[2]/h2/text()').extract_first()
  >             print(author)
  > ```
  - SitemapSpider

  > 使用网站的 `sitemap` 文件作为初始文件进行爬取

  - CSVFeedSpider

  > 使用 `CSV` 文件作为初始文件进行爬取

  - XMLFeedSpider

  > 使用 `XML` 文件作为初始文件进行爬取

#### （2）重载、函数（基于 scrapy.Spider）

- 重载

> ~~~python
> # 此方法必须返回一个可迭代的第一个请求来抓取这个爬虫。
> # 有了start_requests()，就不写了start_urls，写了也没有用
> start_requests（）
> 
> # 默认回调
> parse(response)
> 
> # 发送日志消息logger
> log(message[, level, component])
> 
> # 爬虫关闭时回调
> closed(reason)
> 
> ~~~

- 函数

> - yield 
>
> 返回数据对象到数据队列中，yield 可返回的对象包括None、Dict、str、scrapy.Item、scrapy.Request。
>
> - 返回 scrapy.Item
>
> ~~~python
> class TestItem(scrapy.Item):
>     # define the fields for your item here like:
>     name = scrapy.Field()
> ~~~
>
> ~~~python
> class TestSpider(scrapy.Spider):
>     ...
>     def parse(self, response):
>         item = TestItem()
>         ...
>         
>         yield item
> ~~~
>
> - 返回 scrapy.Request
>
> ~~~python
> class TestSpider(scrapy.Spider):
>     # ...
>     def parse(self, response):
>         item = TestItem()
>         # ...
>         # 下一步调用 url，使用 parse2 去进行解析。meta 传参使用，下一个回调 parse2 中使用 response.meta 获取 meta。
>         yield scrapy.Request(url, callback=parse2, meta=meta_item)
>         
>     def parse2(self, response):
>         meta = response.meta
>         # ...
> ~~~

- 传参

> Spider crawl参数使用该-a选项通过命令 传递。例如：
>
> ```sh
> scrapy crawl myspider -a category=para0
> ```
>
> spider中对应添加 `__init__()` 函数进行参数的接收
>
> ~~~python
> # para0 与 命令中的 category=para0 对应
> def __init__(self, para0=None, *args, **kwargs):
>     self.para0 = para0	# 接收参数
>     super(NovelSpider, self).__init__(*args, **kwargs)
> ~~~

### 2、pipline

### 3、middleware

### 4、logging

### 5、setting

## 四、部署

使用 `Scrapyd` 部署在线服务。客户端可通过 `restapi` 接口，以 `json` 的格式进行爬虫的上传（已存在相应的客户端进行上传，不必再开发）。

[Scrapyd — Scrapyd 1.2.0 documentation](https://scrapyd.readthedocs.io/en/stable/)

[scrapy/scrapyd: A service daemon to run Scrapy spiders (github.com)](https://github.com/scrapy/scrapyd/)

## 五、Scrapy-Redis 及分布式

scrapy-redis是一个基于redis的scrapy组件，用于快速实现scrapy项目的分布式部署和数据爬取

![img](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211009-1851.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)



[Scrapy-redis的两种分布式爬虫的实现 - 简书 (jianshu.com)](https://www.jianshu.com/p/5baa1d5eb6d9)



另，可使用scrapyd提供的接口，结合docker进行不同爬虫的部署，自定义实现爬虫调度的分布式系统。