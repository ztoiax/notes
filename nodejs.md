# nodejs

- http库采用http1.1的keep-alive, 连接可以重复使用

- 事件检查上使用epoll而不是select

```js
console.log('hello world')

# 第二个参数:多少毫秒后, 调用第一个参数的回调函数
# function{}类似lisp的lambda
setTimeout(function(){
    console.log('hello world');
    }, 2000)

# 每2000毫秒调用一次回调函数
setInterval(function(){
    console.log('hello world');
    }, 2000)
```

- socket
```js
var net = require("net");
net.createServer(function(sock){
    sock.on("data", function(data){
        sock.write(data);
});}).listen(8000)
```
```sh
# 输入字符串回车后, 会以相同字符串返回
netcat 127.0.0.1 8000
```
