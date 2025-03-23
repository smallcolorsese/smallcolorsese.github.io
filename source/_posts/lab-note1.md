---
title: 学习笔记lab1
date: 2025-03-11 18:14:57
tags: 学习笔记
cover: /image/lab_note/acg.gy_27.webp
---

# 这里主要是放一些平常学习中感觉值得记下来的知识点

# 一 ： isdigit()遇到的问题

在python中，isdigit()这个函数是用于检查一个字符串是不是整数，但当遇到例如 **-10**, **12.5**这样的数字就没办法检测了（python中不知道为什么没有检查小数的函数），所以我们需要自己定义一个函数，功能是检查字符串中是不是**数字**（包含整数，负数，小数），代码如下：
```
def digital(a:str) -> bool:
    pattern = re.compile("-?\d+(\.\d+)?$")
    return bool(pattern.match(a))
```
这是使用正则表达式(regex)的办法来推断（可能也得开一章写一下正则表达式），如果为数字则输出True，否则为False
