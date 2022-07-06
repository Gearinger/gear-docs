### JavaScript 注释规范

~~~js
/**
* @function 处理表格的行
* @description 合并Grid的行
* @param grid {Ext.Grid.Panel} 需要合并的Grid
* @param cols {Array} 需要合并列的Index(序号)数组；从0开始计数，序号也包含。
* @param isAllSome {Boolean} ：是否2个tr的cols必须完成一样才能进行合并。true：完成一样；false(默认)：不完全一样
* @return void
* @author polk6 2015/07/21 
* @example
* _________________ _________________
* | 年龄 | 姓名 | | 年龄 | 姓名 |
* ----------------- mergeCells(grid,[0]) -----------------
* | 18 | 张三 | => | | 张三 |
* ----------------- - 18 ---------
* | 18 | 王五 | | | 王五 |
* ----------------- -----------------
*/
function mergeCells(grid: Ext.Grid.Panel, cols: Number[], isAllSome: boolean = false) {
    // Do Something
}
~~~

### JavaScript 避免代码污染的直接注入

> 将执行内容包装成方法直接执行，避免将多余的变量暴露出来

~~~js
(
    function(){
        function test(a){
            alert(a);
        }

        test("123213");
    }
)()
~~~

### 关于共享文档、博客

#### （1）GitBook

[GitBook - Where software teams break knowledge silos.](https://www.gitbook.com/)

采用 MarkDown 格式，满足多人协作。有在线版本的个人免费、团队收费模式，也存在开源项目用于本地搭建（开源版本已不活跃维护）。

#### （2）Hexo

markdown 格式，多主题的静态 html 生成，简单轻量。

#### （3）Docsify

无需额外生成静态文件，原生支持 markdown 格式的超轻量文档工具。（需要手动排版首页和目录）

#### （4）Notion

#### （5）wolai

#### （6）石墨

#### （7）语雀

#### （8）印象笔记

#### （9）Observable

用于数据可视化，半代码半文本。

### 关于原型设计

#### （1）Axure

#### （2）Figma

#### （3）Adobe XD

### 关于前端动效

#### （1）Lottie

AE 制作动效数据，导出为 Json 文件，供前端直接调用。

### 公共服务电子地图瓦片数据规范

![image-20220629175524865](https://raw.githubusercontent.com/Gearinger/GearSetting/main/picgo/20220629-175525.png)
