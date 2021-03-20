# 爬虫

## Beautiful Soup

```py
from bs4 import BeautifulSoup

soup = BeautifulSoup(open("index.html"), "lxml")
soup1 = soup.find_all("div", {"class": "module-news mt15"})

list1 = []
for i in soup.dd:
    if i != ' ':
        s = BeautifulSoup(str(i), "lxml")
        list1 = list1 + s.a.contents
print(list1)
```

```py
from urllib.request import urlopen
html = urlopen("https://www.guancha.cn/")
# 获取的html内容是字节，将其转化为字符串
html_text = bytes.decode(html.read())
print(html_text)
```

## re

```py
pattern = re.compile(r'>.*</a>')
result = pattern.findall(html_text)
print(result)
```
