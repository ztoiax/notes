# lua

- `#` 获取类型长度

```lua
str1 = 'hello'
print(#str1) -- 5

print(# 'hello') -- 5
```

## 数据类型

### string(字符串)

- `..` 连接字符串. 由于字符串是不可变类型, 连接字符串实际是新建一个新的字符串

```lua
print('hello'..'world') -- helloworld
```

#### string库


- 5.3开始使用utf-8编码

    - string库的`reverse` `upper` `lower` `byte` `char` 函数只支持1个字节编码的字符串，这意味着不支持中文

    ```lua
    str = '你好啊'
    print(string.reverse(str)) -- "��彥堽�"
    ```

    - `len` `sub` 支持utf-8字符串

    ```lua
    str1 = '你好啊'
    str2 = string.sub(str1, 2, -2)
    print(str2) -- 'ell'

    str = '你好啊'
    print(string.len(str))
    -- sub(): 删除字符串里的字符。实际上是创建新字符串
    print(string.sub(str, 2, -1)) -- "��好啊"
    ```

### table(表)

- lua默认使用表来存储全局变量

- 未赋值的变量为`nil`值
    ```lua
    t = {}
    print(t[1]) -- nil
    ```

- 也可以通过对已有值的变量赋值'nil'，将其删除
    ```lua
    t = {}
    t[1] = 10
    print(t[1]) -- 10
    t[1] = nil
    print(t[1]) -- nil
    ```

    - 假设有10000个节点的邻居图, 也就是10000 * 10000, 一亿个元素. 设置每个节点最多只有5个邻居, 也就是只有5万个元素不为nil. 对于lua来说, nil值不占用内存

- stack(栈)

```lua
table1 = {}

-- push
table.insert(table1, i)

-- pop
table.remove(table1)
```

- queue(队列)
```lua
table1 = {}

-- enqueue
table.insert(table1, 1, i)

-- denqueue
table.remove(table1, 1)
```

- unpack()
```lua
table1 = {1, 2, 3, 4, 5}

function unpack(t, i, n)
    i = i or 1
    n = n or #t
    if i <= n then
        return t[i], unpack(t, i+1, n)
    end
end

print(unpack(table1, 1, 2)) -- 1, 2
```

- 链表
```
link = nil
link = {next = link, data = data}

local link1 = link

local l = link1
for i = 1, 10 do
    link1.data = i
    l = link1.next
end

local l = link1
while l do
    print(l.data)
    l = l.next
end
```

- 双向链表
```lua
function doubleLink()
    return {first = 1, last = -1}
end

-- push
function pushFirst(link, data)
    local first = frist - 1
    link.first = first
    link[first] = data
end

function pushLast(link, data)
    local last = last + 1
    link.last = last
    link[last] = data
end

-- pop
function popFirst(link)
    local first = link.first
    local data = link[first].data
    if first > link.last then error('link is empty') end
    link[first] = nil
    link.first = first + 1
    return data
end

function popLast(link)
    local last = link.last
    local data = link[last].data
    if link.first > last then error('link is empty') end
    link[last] = nil
    link.last = last - 1
    return data
end
```

## io

```lua
file = io.open("/tmp/test", "r")
print(file:read())

file.close()
```

## [函数式编程库](https://github.com/luafun/luafun)
## [OOP库](https://github.com/kikito/middleclass)
