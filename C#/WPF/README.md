# WPF相关记录

## 常用控件的使用示例

### devexpress中GridControl（表格）

~~~xaml
 <dxg:GridControl  
      Grid.Row="1"
      ItemsSource="{Binding SelectedSummaryInfos}"
      Margin ="5" >
            <dxg:GridControl.View >
                <dxg:TableView Name="SummaryTable"  ShowIndicator="False" ShowGroupPanel="False" AutoWidth="True" HorizontalContentAlignment="Center"/>
            </dxg:GridControl.View>
            <dxg:GridControl.Columns>
                <dxg:GridColumn   Header="楼层" Binding="{Binding FloorName}" ReadOnly="True"/>
                <dxg:GridColumn   Header="类型" Binding="{Binding QuantificationType}" ReadOnly="True"/>
                <dxg:GridColumn   Header="级别" Binding="{Binding RType}">
                    <dxg:GridColumn.CellTemplate>
                        <DataTemplate>
                            <TextBlock Text="{Binding RowData.Row.RType}" FontFamily="SJQY"></TextBlock>
                        </DataTemplate>
                    </dxg:GridColumn.CellTemplate>
                </dxg:GridColumn>
                <dxg:GridColumn   Header="直径(mm)" Binding="{Binding Diameter}" ReadOnly="True" />
                <dxg:GridColumn   Header="总长(m)" Binding="{Binding Quantity,StringFormat={}{0:###.###}}" ReadOnly="True"/>
                <dxg:GridColumn   Header="总重(t)" Binding="{Binding Weight,StringFormat={}{0:###.###}}" ReadOnly="True" />
            </dxg:GridControl.Columns>
 </dxg:GridControl>
~~~

## ItemsControl

ItemsControl是ListBox、ListView、TreeView、DataGrid等其他控件的父类。也可直接作为控件使用

~~~xaml

<Grid>
    <Grid.RowDefinitions>
        <RowDefinition Height="Auto" />
        <RowDefinition />
        <RowDefinition />
    </Grid.RowDefinitions>

    <ItemsControl VerticalAlignment="Top">
        <ItemsControl.ItemTemplate>
            <DataTemplate>
                <Button Command="{Binding}" Content="{Binding}" Background="red"
                        CommandTarget="{Binding ElementName=EditRegion}" />
            </DataTemplate>
        </ItemsControl.ItemTemplate>

        <ItemsControl.ItemsPanel>
            <ItemsPanelTemplate>
                <StackPanel Orientation="Horizontal" Background="Green"/>
            </ItemsPanelTemplate>
        </ItemsControl.ItemsPanel>

        <ItemsControl.Items>
            <x:Static Member="ApplicationCommands.Cut"/>
            <x:Static Member="ApplicationCommands.Copy"/>
            <x:Static Member="ApplicationCommands.Paste"/>
        </ItemsControl.Items>
        <!--
            <x:Static Member="ApplicationCommands.Cut"/>
            <x:Static Member="ApplicationCommands.Copy"/>
            <x:Static Member="ApplicationCommands.Paste"/>
            -->
    </ItemsControl>

    <TextBox Name="EditRegion" Grid.Row="1"/>

    <ListBox Grid.Row="2">
        <ListBox.Items>
            <ListBoxItem>
                <x:Static Member="ApplicationCommands.Cut"/>
            </ListBoxItem>
            <ListBoxItem>
                <x:Static Member="ApplicationCommands.Copy"/>
            </ListBoxItem>
            <ListBoxItem>
                <x:Static Member="ApplicationCommands.Paste"/>
            </ListBoxItem>
        </ListBox.Items>
    </ListBox>
</Grid>
~~~



## DataGrid

DataGrid 可使用 DataTable 作为 ItemSource

~~~xaml
<DataGrid CanUserResizeColumns="True"
          HorizontalAlignment="Center"
          AutoGenerateColumns="False"
          Background="White"
          VerticalContentAlignment="Center"
          HorizontalContentAlignment="Center"
          CanUserAddRows="False"
          ItemsSource="{Binding FittingHoleModelList}" RowHeight="20">
    <DataGrid.Columns>
        <DataGridTemplateColumn Width="50">
            <DataGridTemplateColumn.CellTemplate>
                <DataTemplate>
                    <CheckBox IsChecked="{Binding IsChecked, UpdateSourceTrigger=PropertyChanged}" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="0" Padding="0"/>
                </DataTemplate>
            </DataGridTemplateColumn.CellTemplate>
        </DataGridTemplateColumn>

        <DataGridTemplateColumn Header="统一编号" IsReadOnly="True" Width="*" HeaderStyle="{StaticResource HeaderStyle}">
            <DataGridTemplateColumn.CellTemplate>
                <DataTemplate>
                    <TextBlock VerticalAlignment="Center" HorizontalAlignment="Center" Text="{Binding Id, Mode=TwoWay}"/>
                </DataTemplate>
            </DataGridTemplateColumn.CellTemplate>
        </DataGridTemplateColumn>
        <DataGridTemplateColumn Header="拟合孔名称" IsReadOnly="True" Width="1.2*" HeaderStyle="{StaticResource HeaderStyle}">
            <DataGridTemplateColumn.CellTemplate>
                <DataTemplate>
                    <TextBlock VerticalAlignment="Center" HorizontalAlignment="Center" Text="{Binding FittingHoleName, Mode=TwoWay}"/>
                </DataTemplate>
            </DataGridTemplateColumn.CellTemplate>
        </DataGridTemplateColumn>
    </DataGrid.Columns>
</DataGrid>

~~~

## 图标

Win10 自带Segoe MDL2 图标，可直接使用一串字符表示出一个矢量图标。

FontFamily : Segoe MDL2 Assets 字体

https://docs.microsoft.com/zh-cn/windows/uwp/design/style/segoe-ui-symbol-font

> 另可在windows商店中安装“字符大全集”



## 添加启动加载界面



首先在工程中加入一张启动界面要显示的图片（例如：界面.jpg），在工程中选中图片右键--》属性，如下图

![img](https://i.loli.net/2021/01/14/SMdTspPzevkoZaU.png)

将生成操作一栏设置成 SplashSrceen即可。

如果想要更多的设置，可以在app.xaml.cs中重写OnStartUp函数。

代码片段如下：

```c#
public partial class App : Application    
{        
    protected override void OnStartup(StartupEventArgs e)        
    {            
        SplashScreen s = new SplashScreen("界面1,jpg");           
        //显示初始屏幕 自动关闭设置false            
        s.Show(false);            
        //在3秒后关闭            
        s.Close(new TimeSpan(0, 0, 3));            
        base.OnStartup(e);        
    }    
}
```

## 控件库

### 1、DevExpress

基本包含常用的所有控件和基础类库

### 2、Aduskin

简约好看，2020年7月29日发布

