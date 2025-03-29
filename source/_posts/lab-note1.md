---
title: 学习笔记lab1
date: 2025-03-11 18:14:57
tags: 学习笔记
cover: /image/lab_note/acg.gy_27.webp
---

# 这里主要是放一些平常学习中感觉值得记下来的知识点

# 一 ：isdigit()遇到的问题

在python中，isdigit()这个函数是用于检查一个字符串是不是整数，但当遇到例如 **-10**, **12.5**这样的数字就没办法检测了（python中不知道为什么没有检查小数的函数），所以我们需要自己定义一个函数，功能是检查字符串中是不是**数字**（包含整数，负数，小数），代码如下：
```
def digital(a:str) -> bool:
    pattern = re.compile("-?\d+(\.\d+)?$")
    return bool(pattern.match(a))
```
这是使用正则表达式(regex)的办法来推断（可能也得开一章写一下正则表达式），如果为数字则输出True，否则为False

# 二 ：字典遇到的问题

![](/image/lab_note/lab9.png)

遇到的问题如上，这是一个更新字典内容的练习题，本题是定义一个函数return_subject_grade将subject_grade这个字典中subject这个key值改为new_grade。

问题在于第二段话 *This function creates a copy of the original dictionary subject_grade....* 如何去复制一个字典是我一开始疏漏的点，以我一开始的思维来说，创建一个副本，只需要将subject_grade的值附到副本上去即可，即
```
tem_subject_grade = subject_grade
```
但是事实并非是这样，事实上，tem_subject_grade依旧指向subject_grade，如果你修改tem_subject_grade的值，subject_grade的值会被一同修改，这一点查看内存id也可以发现
```
a = {90: ['Math'], 75: ['English'], 95: ['Python'], 88: ['Biology']}
b = a
print(id(a)) # 查看内存位置
print(id(b))

#输出
2737371232704
2737371232704 #内存id相同
```

因此真正的创建副本的办法是使用python字典的内置方法copy()，当你需要创建一个副本，只需要使用这个关键字，就可以在不会修改原字典的情况下，而是创建副本对副本进行修改。
```
tem_subject_grade = subject_grade.copy()
```

