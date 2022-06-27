## JavaScript 注释规范

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

