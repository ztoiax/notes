# browsers

- [chrome浏览器F12官方文档](https://developer.chrome.com/docs/devtools/network/reference/?utm_source=devtools#timing-explanation)

- 《Inside look at modern web browser》

    - [Inside look at modern web browser (part 1)](https://developer.chrome.com/blog/inside-browser-part1/)
    - [Inside look at modern web browser (part 2)](https://developer.chrome.com/blog/inside-browser-part2/)
    - [Inside look at modern web browser (part 3)](https://developer.chrome.com/blog/inside-browser-part3/)
    - [Inside look at modern web browser (part 4)](https://developer.chrome.com/blog/inside-browser-part4/)

    - [Inside look at modern web browser (part 1)中文翻译](https://zhuanlan.zhihu.com/p/99394757)

    - [Inside look at modern web browser (part 2 3 4)的中文翻译](https://lisongfeng.cn/2019/06/05/understanding-modern-browsers.html)

    - [腾讯技术工程：深入理解浏览器原理](https://cloud.tencent.com/developer/article/1489018)

        > 从第二部分开始，对Inside look at modern web browser，进行翻译、理解、总结提炼、条理化、加入应用示例、进行相关知识补充扩展而来。

        ![image](./Pictures/web/chromium-arch.avif)

    [腾讯云开发者：揭秘字节码到像素的一生！Chromium 渲染流水线](https://cloud.tencent.com/developer/article/2187276)

    - [objtube的卢克儿视频：【干货】浏览器是如何运作的？](https://www.bilibili.com/video/BV1x54y1B7RE)

        > 主要基于Inside look at modern web browser讲解，还有其他技术文档

- [How browsers work](https://web.dev/howbrowserswork/)

- [Chromium Design Docs](https://chromium.googlesource.com/chromium/src/+/main/docs/design/README.md)

- [rail用户性能模型](https://web.dev/rail/)

# WebAssembly

- [李银城：WebAssembly与程序编译](https://www.rrfed.com/2017/05/21/webassembly/)

# 数据库

- [李银城：前端与 SQL](https://www.rrfed.com/2017/06/11/sql/)

# HTML

- [Templating in HTML](https://kittygiraudel.com/2022/09/30/templating-in-html/)

- [李银城：HTML/CSS/JS编码规范](https://www.rrfed.com/2017/08/20/html-css-js-code-specification/)

- [李银城：我知道的跨域与安全](https://www.rrfed.com/2018/01/20/cross-origin/)

- [jsonplaceholder： restful api测试网站](https://jsonplaceholder.typicode.com/)

    - `GET`(查)

        ```sh
        # 返回json格式
        curl 'https://jsonplaceholder.typicode.com/todos/1'

        # 返回userid=5
        curl 'https://jsonplaceholder.typicode.com/todos?userId=5'
        ```

    - `POST`(增)

        ```sh
        curl -d "userId=100&title=post test" -X POST 'https://jsonplaceholder.typicode.com/todos'
        ```

    - `PATCH`(改)

        ```sh
        curl -d "title=patch test" -X PATCH 'https://jsonplaceholder.typicode.com/todos/123'
        ```

    - `DELETE`(删)

        ```sh
        curl -X DELETE 'https://jsonplaceholder.typicode.com/todos/321'
        ```

- 图片优先选择avif

```html
<picture>
  <source type="image/avif" srcset="cow.avif" />
  <source type="image/webp" srcset="cow.webp" />
  <img src="cow.jpg" srcset="cow.png" alt="Cow" />
</picture>
```

# CSS

- [Chrome 团队制作的 CSS 教程](https://web.dev/learn/css/)

- [css教程](https://www.pengfeixc.com/tutorial/css/introduction)

- [css技巧](https://github.com/AllThingsSmitty/css-protips)

- [How to create high-performance CSS animations](https://web.dev/animations-guide/)

- [Color Formats in CSS（详细介绍 CSS 颜色的各种格式）](https://www.joshwcomeau.com/css/color-formats/)

- 图片优先选择avif
```css
.box {
  background-image: url("cow.jpg"); /* fallback */
  background-image: image-set(
    url("cow.avif") type("image/avif"),
    url("cow.jpg") type("image/jpeg"));
}
```

# js

- [阮一峰：Deno 运行时入门教程：Node.js 的替代品](https://www.ruanyifeng.com/blog/2021/01/deno-intro.html)

- [objtube的卢克儿的视频：【干货】8分钟带你了解V8引擎是如何运行JS！都2020年了还不知道什么是V8？](https://www.bilibili.com/video/BV1zV411z7RX)

    - v8旧架构

        ![image](./Pictures/web/v8-old.avif)

    - v8新架构（2017年后）

        ![image](./Pictures/web/v8-new.avif)

        ![image](./Pictures/web/v8-new1.avif)

        - 假设优化后的热点代码一直传递的是int类型，如果下一次传递的是其它类型，就需要`deoptimization` 返回解析器生成bytecode运行，这样执行速度就会变慢。因此每次传递的参数最好保持同一类型。
