1、table.txt 用来配置需要备份的表，格式为 用户名+.(英文点)+表名，表与表之间用逗号(英文)隔开。
例如：bsitsqp.demo02_hs,bsitsqp.demo01_hs,viid.demo01_hs
2、如果要备份整个数据库，将上述代码中 tables=(%tableExp%) 去掉即可；
3、如果要备份特定用户的数据 ，修改用户名 密码即可。
4、定时备份，在Windows 中添加定时任务即可