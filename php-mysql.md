# php-mysql

```sh
取消 /etc/php/php.ini 中 下面行前面的注释 :

extension=pdo_mysql.so
extension=mysqli.so
```

```sh
# 连接
mysqli_connect(host, username, password, dbname,port, socket);

<?php
$dbhost = '127.0.0.1';  // mysql服务器主机地址
$dbuser = 'root';            // mysql用户名
$dbpass = 'YouPassword';          // mysql用户名密码
$conn = mysqli_connect($dbhost, $dbuser, $dbpass);
if(! $conn )
{
    die("Could not connect: \n" . mysqli_error());
}
echo '数据库连接成功！';
mysqli_close($conn);
?>
```
