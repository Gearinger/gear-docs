### DBF文件的处理

#### 1、DotNetDBF

[dll文件路径](.\文件)

[使用说明](https://github.com/ekonbenefits/dotnetdbf/blob/master/DotNetDBF.Test/Test.cs)

~~~C#
//示例
/// <summary>
/// 插入到dbf文件
/// </summary>
/// <param name="dbfPath">dbf文件路径</param>
/// <param name="rowList">需插入的内容</param>
/// <returns></returns>
private bool InsertIntoDbf(string dbfPath, List<List<KeyValuePair<string, string>>> rowList)
{
    if (rowList.Count == 0
        || rowList[0].Count == 0)
    {
        return true;
    }
    using (DBFWriter writer = new DBFWriter(dbfPath))
    {
        writer.CharEncoding = System.Text.Encoding.GetEncoding("GB2312");
        foreach (var row in rowList)
        {
            var tempStringList = new List<object>();
            foreach (var kv in row)
            {
                bool isAdded = false;
                string fTypeName = "";
                foreach (var f in writer.Fields)
                {
                    fTypeName = f.Type.Name;
                    if (f.Name == kv.Key)
                    {
                        switch (fTypeName)
                        {
                            case "String":
                                tempStringList.Add((kv.Value));
                                break;
                            case "Decimal":
                                decimal.TryParse(kv.Value, out decimal tempNum);
                                tempStringList.Add(tempNum);
                                break;
                            case "DateTime":
                                System.DateTime.TryParse(kv.Value, out System.DateTime tempDate);
                                tempStringList.Add(tempDate);
                                break;
                            default:
                                tempStringList.Add(new object());
                                break;
                        }
                        isAdded = true;
                        break;
                    }
                }
                if (!isAdded)
                {
                    switch (fTypeName)
                    {
                        case "String":
                            tempStringList.Add("");
                            break;
                        case "Decimal":
                            tempStringList.Add(0);
                            break;
                        case "DateTime":
                            tempStringList.Add(new System.DateTime());
                            break;
                        default:
                            tempStringList.Add(new object());
                            break;
                    }
                }
            }
            writer.WriteRecord(tempStringList.ToArray());
        }
    }
    return true;
}

~~~

