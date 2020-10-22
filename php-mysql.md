# php-mysql

取消 /etc/php/php.ini 中 下面行前面的注释 :

- extension=pdo_mysql.so
- extension=mysqli.so

## 连接

`mysqli_connect(host, username, password, dbname,port, socket);`

```php
<?php
$dbhost = '127.0.0.1';   // mysql服务器主机地址
$dbuser = 'root';        // mysql用户名
$dbpass = 'YouPassword'; // mysql用户名密码
$conn = mysqli_connect($dbhost, $dbuser, $dbpass);
if(! $conn )
{
    die("Could not connect: \n" . mysqli_error());
}
echo '数据库连接成功！';
mysqli_close($conn);
?>
```

## 执行 sql 语句

'mysqli_query($conn,$sql );'

```php
# 创建数据库
<?php
$dbhost = '127.0.0.1';   // mysql服务器主机地址
$dbuser = 'tz';          // mysql用户名
$dbpass = '201997102'; // mysql用户名密码
$conn = mysqli_connect($dbhost, $dbuser, $dbpass);
if(! $conn )
{
  die('连接错误: ' . mysqli_error($conn));
}
echo '连接成功<br />';
$sql = 'CREATE DATABASE phptest';
$retval = mysqli_query($conn,$sql );
if(! $retval )
{
    die('创建数据库失败: ' . mysqli_error($conn));
}
echo "数据库 RUNOOB 创建成功\n";
mysqli_close($conn);
?>
```

## 选择数据库

```php
mysqli_select_db($conn, 'phptest' )
```
