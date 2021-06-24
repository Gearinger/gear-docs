# DevExpress中Word、Wpf文档处理

## Word

### 结构

Word模型中，主要结构包括Header、Main document body、Footer。主要内容在逻辑上可划分为多个Section，每个Section包含多个Paragraph。同时Section可包含多个Page。

![image-20200312153208059](.\image-20200312153208059.png)

另外，还包括主要用于修饰的内容，**lists**, **styles**, **tables**,**inline pictures**, **floating  objects** (pictures and text boxes), **bookmarks**, **hyperlinks** and  **comments**。其中，Tables和Comments包含Paragraph。

---

### 基本操作

#### 创建、加载、追加、保存、导出文档

```C#
RichEditDocumentServer server = new RichEditDocumentServer();
//创建
server.CreateNewDocument(file);
server.CreateNewDocument(stream);
//加载
server.LoadDocument(file, DocumentFormat.OpenXml);
//追加
server.Document.AppendDocumentContent(file, DocumentFormat.OpenXml);
//保存
server.SaveDocument(file, DocumentFormat.OpenXml); 
//导出为其他格式
server.ExportToPdf(file, options);					//pdf
server.SaveDocument(file, DocumentFormat.Html);		//html
server.SaveDocument(file, DocumentFormat.OpenXml);	//docx
```

#### 页面样式设置

页面样式可通过Section.Page  and Section.Margins 设置页面样式和边距。页面样式的设置以Section为单位。Page只作为属性，不作为可编辑基本单位。

```C#
//设置Page长宽
Section.Page.Width = 3550;
Section.Page.Height = 2500;
//设置页面大小
Section.Page.PaperKind = System.Drawing.Printing.PaperKind.A4;
//设置单位长度
document.Unit = DevExpress.Office.DocumentUnit.Inch;

```

#### 内容编辑~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

##### Text

##### Tables

##### BookMark

##### Style

##### Pictures

##### 其他





## Pdf

### 结构

Pdf模型中，主要包括Document和Graphics。Document中，以Page为单位，对pdf的样式进行设计；Graphics主要是用作画板，绘制图形或添加文本内容，并直接覆盖到Page的前景或背景中。

### 页面样式

Pdf中用PageBox描述页面大小，PageBox包含五个不同的Box。

**MediaBox**用来描述页面的高度和宽度；

**CropBox** 定义了页面内容的裁剪到区域；

**BleedBox** 定义了当用于生产环境时页面内容将被裁剪到的区域；

**TrimBox** 定义了最终页面想要的尺寸（以上尺寸应该都大于TrimBox）；

**ArtBox** 定义了某些特殊用途的页面中的区域，不常使用（主要用于页面广告控制）

```C#
//设置当前页的样式
documentProcessor.Document.Pages[documentProcessor.Document.Pages.Count - 1].MediaBox = new PdfRectangle(-60, -80, 535.35, 762);
documentProcessor.Document.Pages[documentProcessor.Document.Pages.Count - 1].TrimBox = new PdfRectangle(-60, -80, 535.35, 762);
documentProcessor.Document.Pages[documentProcessor.Document.Pages.Count - 1].BleedBox = new PdfRectangle(-60, -80, 535.35, 762);
documentProcessor.Document.Pages[documentProcessor.Document.Pages.Count - 1].CropBox = new PdfRectangle(-60, -80, 535.35, 762);
```

### 内容添加

```c#
using System.Drawing;
using System.Collections.Generic;
using DevExpress.Pdf;

namespace CreateGraphics {
    class Program {
    	//dpi
        const float DrawingDpi = 72f;

        static void Main(string[] args) {
            using (PdfDocumentProcessor processor = new PdfDocumentProcessor()) {
                processor.LoadDocument("..\\..\\RotatedDocument.pdf");
                using (SolidBrush textBrush = new SolidBrush(Color.FromArgb(100, Color.Blue)))
                    AddGraphics(processor, "text", textBrush);
                processor.SaveDocument("..\\..\\RotatedDocumentWithGraphics.pdf");
            }
        }

        static void AddGraphics(PdfDocumentProcessor processor, string text, SolidBrush textBrush) {
            IList<PdfPage> pages = processor.Document.Pages;
            for (int i = 0; i < pages.Count; i++) {
                PdfPage page = pages[i];
                //创建Graphics
                using (PdfGraphics graphics = processor.CreateGraphics()) {
                    SizeF actualPageSize = PrepareGraphics(page, graphics);
                    //设置字体，添加文本
                    using (Font font = new Font("Segoe UI", 20, FontStyle.Regular)) {
                        SizeF textSize = graphics.MeasureString(text, font, PdfStringFormat.GenericDefault);
                        PointF topLeft = new PointF(0, 0);
                        PointF bottomRight = new PointF(actualPageSize.Width - textSize.Width, actualPageSize.Height - textSize.Height);
                        graphics.DrawString(text, font, textBrush, topLeft);
                        graphics.DrawString(text, font, textBrush, bottomRight);
                        //将graphics中内容添加到page前景中
                        graphics.AddToPageForeground(page, DrawingDpi, DrawingDpi);
                    }
                }
            }
        }

        //graphics的旋转、位移
        static SizeF PrepareGraphics(PdfPage page, PdfGraphics graphics) {
            PdfRectangle cropBox = page.CropBox;
            float cropBoxWidth = (float)cropBox.Width;
            float cropBoxHeight = (float)cropBox.Height;

            switch (page.Rotate) {
                case 90:
                    graphics.RotateTransform(-90);
                    graphics.TranslateTransform(-cropBoxHeight, 0);
                    return new SizeF(cropBoxHeight, cropBoxWidth);
                case 180:
                    graphics.RotateTransform(-180);
                    graphics.TranslateTransform(-cropBoxWidth, -cropBoxHeight);
                    return new SizeF(cropBoxWidth, cropBoxHeight);
                case 270:
                    graphics.RotateTransform(-270);
                    graphics.TranslateTransform(0, -cropBoxWidth);
                    return new SizeF(cropBoxHeight, cropBoxWidth);
            }
            return new SizeF(cropBoxWidth, cropBoxHeight);
        }
    }
}

```

