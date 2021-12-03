1、使用`nuget`引入`System.Data.SQLite`

2、参考[概述 - Microsoft.Data.Sqlite | Microsoft Docs](https://docs.microsoft.com/zh-cn/dotnet/standard/data/sqlite/?tabs=netcore-cli)

~~~C#
using (var connection = new SqliteConnection("Data Source=hello.db"))
{
    connection.Open();

    var command = connection.CreateCommand();
    command.CommandText =
    @"
        SELECT name
        FROM user
        WHERE id = $id
    ";
    command.Parameters.AddWithValue("$id", id);

    using (var reader = command.ExecuteReader())
    {
        while (reader.Read())
        {
            var name = reader.GetString(0);

            Console.WriteLine($"Hello, {name}!");
        }
    }
}
~~~

> 注：由于`nuget`存在大量不同平台、版本的sqlite包，很容易混淆，必须使用`System.Data.SQLite`

