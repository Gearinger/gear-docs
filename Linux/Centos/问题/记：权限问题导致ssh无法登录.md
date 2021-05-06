问题：

~~~sh
# 查看登陆日志
cat /var/log/secure
Authentication refused: bad ownership or modes for directory /root

~~~

问题原因：/root文件夹的权限存在问题。sshd要求/root权限不能太高也不能太低，一般为505

解决办法：

~~~sh
chmod 505 /root
~~~

