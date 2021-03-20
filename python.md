# python

## 基本概念

- 一切皆是对象

  - 每个对象由 `id(地址)` `type(类型)` `value(值)` 组成

    `a is b` 实际上为 `id(a) == id(b)`. `is` 效率高于 `==`

  - `list` `dict` `set` 为**可变数据**,值的修改**不需要创建新对象**

  - `int` `str` `tuple` 为**不可变数据**,值的修改**需要创建新对象**

    - `a = 256` `b = 256` 两者 id 相同

      > python 维护一个(0, 256)的常量值, 这范围内的值的变量 id 相同

    - `a = 257` `b = 257` 两者 id 不相同

    - `a = 257` `b = a` 两者 id 相同

### 动态类型

- 字典的 `key`, `value` 可以是其它类型

  - 注意:

    **key** 不能为 `list`, `set`

  - 错误:

    `lv = {['hello', 'nihao']: 1}`

    `lv = {{'hello', 'nihao'}: 1}`

    ```py
    kv = {1: 'hello', 2: 'nihao'}
    kl = {1: ['hello', 'nihao']}
    kt = {1: ('hello', 'nihao')}
    ks = {1: {'hello', 'nihao'}}

    sv = {'hello': 1, 'nihao': 2}
    tv = {('hello', 'nihao'): 1}
    ```

- `list`, `tuple`, `set` 转 `dict`

  ```py
  dict([(3, 9), (4, 16), (5, 25)])
  dict(([3, 9], [4, 16], [5, 25]))
  dict(({3, 9}, {4, 16}, {5, 25}))
  ```

- `dict` 转 `list`, `tuple`, `set` 只能保留 `key`:

  ```py
  tuple({1: 'a', 2: 'b'})
  list({1: 'a', 2: 'b'})
  set({1: 'a', 2: 'b'})
  ```

- 要想同时保留 `key` `value` 可以利用 list 保存 key,再循环赋值

  ```py
  D = {'a':1, 'c':3, 'b':2}
  D1 = list(D.keys())
  D1.sort()
  s = tuple()
  for i in D1:
    s = s + (i, D[i])
  ```

- 循环赋值

  ```py
  (x for x in range(1,5))
  tuple(x * 2 for x in 'abc')
  [x for x in range(1,5) if x % 2 == 0]
  ['x' * 2 for x in 'abc']
  {x: x * x for x in range(1,5)}
  ```

## 函数式编程

lambda:

```py
def mul_add(f, g):
    def h(x):
        return f(g(x, x), g(x, x))
    return h

def mul_add(f, g):
    return lambda x: f(g(x, x), g(x, x))

# test
test = mul_add(mul, add)
test(12)
```

### fib(斐波那契)

#### 循环 while, for

```py
def fib(n):
    x = n
    while n > 1:
        n = n - 1
        x = x + n
    return x

def fib(n):
    prev, curr = 1, 0
    for _ in range(n):
        prev, curr = curr, prev + curr
    return curr

# test
fib(10)

def fib1(f, n):
    x = n
    while n > 1:
        n = n - 1
        x = f(x, n)
        print(x)
    return x

# test
fib1(add,10)
fib1(mul,10)
```

#### 迭代

```py
def fib2(x, n):
    def diedai(x, n, s):
        if n >= x:
            s = diedai(x, n - 1, s + n)
        return s
    return diedai(x, n - 1, n)

# test
fib2(0,10)

# 自选函数: f

def fib2(f, x, n):
    def diedai(f, x, n, s):
        if n >= x:
            s = diedai(f, x, n - 1, f(s, n))
        return s
    return diedai(f, x, n - 1, n)


# test
fib2(add, 0, 10)
fib2(mul, 1, 5)

# 步进: y

def fib2(f, x, n, y):
    def diedai(f, x, n, s):
        if n >= x:
            s = diedai(f, x, n - y, f(s, n))
        return s
    return diedai(f, x, n - y, n)

# test
fib2(add, 0, 10, 2)
fib2(mul, 10, 100, 10)
```

#### 泛函

```py
def sum(n, term, next):
    s, x = 0, 1
    while x <= n:
        s, x = s + term(x), next(x)
    return s

def fib(x):
    def fib_next(x):
        return x + 1
    def fib_term(x):
        return x
    return sum(x, fib_term, fib_next)

fib(100)
```

#### tuple(元组)

```py
def maporder(n):
    return tuple(map(lambda x: x + 1, range(0, n)))

def sumorder(n):
    return sum(map(lambda x: x + 1, range(0, n)))

def mapfib(n):
    return tuple(map(fib, range(2, n + 1)))

def mapfib(n):
    return tuple(x for x in range(1, n + 1))

def sumfib(n):
    return sum(map(fib, range(2, n + 1)))

def sumfib(n):
    return sum(fib(x) for x in range(2, n + 1))

# test
maporder(10)
sumorder(10)
mapfib(10)
sumfib(10)

# odd, even
def exfib(n, culc, f):
    return f(filter(culc, range(1, n)))

def odd(n, f):
    return exfib(n, lambda x: x % 2 != 0, f)

def even(n, f):
    return exfib(n, lambda x: x % 2 == 0, f)

odd(10, tuple)
even(10, sum)
```

### pi(圆周率)

```py
def pi(n):
    s, x = 0, 1
    while x <= n:
        s, x = s + 8 / (x * (x + 2)), x + 4
    return s

def pi(n):
    def pi_sum(s, x, n):
        if n >= x:
            s = pi_sum(s + 8 / (x * (x + 2)), x + 4, n)
        return s
    return pi_sum(0, 1, n)

# test
pi(100)
```

```py
def sum(n, term, next):
    def pi_sum(s, x, n, pi_term, pi_next):
        if n >= x:
            s = pi_sum(s + term(x), next(x), n, pi_term, pi_next)
        return s
    return pi_sum(0, 1, n, pi_term, pi_next)

# pi
def pi(x):
    def pi_next(x):
        return x + 4
    def pi_term(x):
        return 8 / (x * (x + 2))
    return sum(x, pi_term, pi_next)

# test
# 8 / (x * (x + 2))
pi(100)
```

### 黄金分割

```py
def square(x):
    return x * x

def successor(x):
    return x + 1

def near(x, f, g):
    return approx_eq(f(x), g(x))

def approx_eq(x, y, tolerance = 1e-5):
    return abs(x - y) < tolerance

def golden_update(guess):
    return 1 / guess + 1

def golden_test(guess):
    return near(guess, square, successor)

def iter_improve(update, test, guess = 1):
    while not test(guess):
        guess = update(guess)
    return guess

# test
# 1 / guess + 1
iter_improve(golden_update, golden_test)
```

### 树形递归

```py
# 指数增长

def tree(n):
    if n == 1:
        return 0
    if n == 2:
        return 1
    return tree(n - 2) + tree(n - 1)

# test
tree(6)
```

### 平方根

```py
def square(x):
    return x * x

def average(x, y):
    return (x + y) / 2

def approx_eq(x, y, tolerance = 1e-5):
    return abs(x - y) < tolerance

def iter_improve(update, test, guess = 1):
    while not test(guess):
        guess = update(guess)
    return guess

def sqrt_update(guess, x):
    return average(guess, x / guess)

def square_root(x):
    def update(guess):
        return average(guess, x / guess)
    def test(guess):
        return approx_eq(square(guess), x)
    return iter_improve(update, test)

# test
# ((x / guess) + guess) / 2
square_root(256)
```

牛顿法:

```py
def square(x):
    return x * x

def successor(k):
    return k + 1

def approx_eq(x, y, tolerance = 1e-5):
    return abs(x - y) < tolerance

def approx_derivative(f, x, delta = 1e-5):
    df = f(x + delta) - f(x)
    return df / delta

def newton_update(f):
    def update(x):
        return x - f(x) / approx_derivative(f, x)
    return update

def iter_improve(update, test, guess = 1):
    while not test(guess):
        guess = update(guess)
    return guess

def find_root(f, initial_guess = 10):
    def test(x):
        return approx_eq(f(x), 0)
    return iter_improve(newton_update(f), test, initial_guess)

def square_root(a):
    return find_root(lambda x: square(x) - a)

def logarithm(a, base = 2):
    return find_root(lambda x: pow(base, x) - a)


# test
square_root(16)

logarithm(32, 2)
```

装饰器:

```py
def IAmDecorator(fun):
    def wrapper(*args, **kw):
        print("我真的是一个装饰器")
        return fun
    return wrapper

@IAmDecorator
def func(h):
    print("我是原函数")

# test
func()
func()(h = 1)
```

## rlist(序列)

```py
def first(rlist):
    return rlist[0]

def rest(rlist):
    return rlist[1]

# insert
def insert(rlist, x):
    return (rlist,x)

def finsert(rlist, x):
    return (x,rlist)

# lengh
def lengh(rlist):
    n = 0
    while rlist != None:
        rlist, n = rest(rlist), n + 1
    return n

# test
rlist = (1, (1, (2, (2, None))))
lengh(rlist)

# get item
def get(rlist, n):
    while n > 0:
        rlist, n = rest(rlist), n - 1
    return first(rlist)

# test
get(rlist, 2)

# nonone
def nonone(rlist):
    if rest(rlist) == None:
        return first(rlist)
    return rlist

# reverse 反转
def reverse(rlist):
    x, rlist = insert(first(rlist),None), rest(rlist)
    while rlist != None:
        x, rlist = insert(first(rlist),x), rest(rlist)
    return x

# 递归
def test(rlist, x):
    if rlist != None:
       x = test(rest(rlist), (first(rlist),x))
    return x

def reverse(rlist):
    return test(rlist, None)

# test
reverse(rlist)

# insert
def ninsert(rlist, x, n):
    len, y, rerlist = lengh(rlist) - n, None, reverse(rlist)
    while rerlist != None:
        y, rerlist = insert(first(rerlist),y), rest(rerlist)
        len = len - 1
        if len == 0:
            y = insert(x, y)
    return y

# test
ninsert(rlist, 0, 2)

def einsert(rlist, x):
    return ninsert(rlist, x, lengh(rlist))

def einsert(rlist, x):
    x = insert(0, None)
    rerlist = reverse(rlist)
    link(x, rerlist)
    return x

# test
einsert(rlist, 0)
```

元组操作序列:

```py
# count 计算一个值,在序列出现的次数
def count(rlist, x):
    n = 0
    while rlist != None:
        if (x == first(rlist)):
            n = n + 1
        rlist = rest(rlist)
    return n

# bug
def count(rlist, x):
    n = 0
    for i in rlist:
        print(i)
        if i == x:
            n = n + 1
    return n

count(rlist, 1)
```

## tuple(元组)

```py
word = "hello Worrld ! in Python"

# 字符串传元组
tuple(word.split())
tuple(w[0] for w in word.split())
tuple(w[0] for w in word.split() if w[0].isupper())
tuple(w[0] for w in word.split() if w[0].islower())

def first(list):
    return list[0]

def iscap(word):
    return word[0].isupper()

def acronym(word, f):
    return tuple(map(f, filter(iscap, word.split())))

def acronym1(word, f):
    return tuple(f(w) for w in word.split() if iscap(w))

# 提取首字母为大写的单词
acronym(word, lambda x: x)

# 提取首字母为大写的字母
acronym(word, lambda x: x[0])

# 转换为小写
acronym(word, lambda x: x[0].lower())
```

```py
def insert(s, x):
    s = s + x
    s = s + ' '
    return s

# insert
def ninsert(n, y, x):
    l, s = 0, ''
    for i in n:
        s = insert(s, i)
        l = l + 1
        if l == y:
            s = insert(s, x)
    return tuple(s.split())

n = ('hello', 'Worrld', '!', 'in', 'Python')
ninsert(n, 3, 'test')
```

## class(类)

```py
class people(object):
    international = 'china'
    def __init__(self, instance):
        self.name = instance
    def age(self, n):
        self.age = n

# test
a = people('tz')
a.age(24)
a.age
a.name
a.international
```

- [class 多重继承](https://mp.weixin.qq.com/s?src=11&timestamp=1616076681&ver=2954&signature=GHjOFjcBaLw0m6z6gIS--ofvy8w**aD4*sYNdLtmmctvPEPV9KogYr*A8rcr2C-WtA54IRNSOFK-exDpNvfcl1i1iX*dmll-DpzMegxRKBQmC8lkWdBtXz5muqI2p0sT&new=1)

## subprocess

```py
# 列表运行
subprocess.call(['echo', '123'])

# 直接运行
subprocess.call('echo 123', shell = True)

# check_output 获取stdout
output = subprocess.check_output('echo 123', shell=True)

# 转换为str
output = subprocess.check_output('echo 123', shell=True, universal_newlines=True)
output.rstrip() # 去除换行符\n

# 获取标准stdout, stderr, return code
output = subprocess.run('echo 123', shell=True, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

output.stdout
output.stderr
output.returncode
```

### clipboard

```py
def getClipboard():
    cmd = 'xclip -selection clipboard -o'
    output = subprocess.check_output(cmd, shell=True, universal_newlines=True)
    return output

def setClipboard(data):
    p = subprocess.Popen(['xclip','-selection','clipboard'], stdin=subprocess.PIPE)
    p.stdin.write(data)
    p.stdin.close()
    retcode = p.wait()

setClipboard('data'.encode())
```

# reference article(优秀文章)

- [python 教程](https://zhuanlan.zhihu.com/p/187297674)

- [python-cheatsheet](https://github.com/gto76/python-cheatsheet)

# 第三方软件资源

- [rich: 可以很容易的在终端输出添加各种颜色和不同风格](https://github.com/willmcgugan/rich)

- [Scalene: 适用于 Python 的高性能，高精度 CPU 和内存分析器](https://github.com/emeryberger/scalene)

- [rembg: 一键扣图](https://github.com/danielgatis/rembg)
