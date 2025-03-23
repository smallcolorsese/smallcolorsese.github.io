---
title: bat脚本编写教程
date: 2025-03-21 17:06:22
tags: 函数使用
cover: /image/bat/www.hacg.me_51.webp
---

# 前言
bat是windows下的批处理文件格式，使用它可以方便的帮助我们进行一些指令的一键完成，下面将介绍一些bat脚本的编写方法。

# 基础语法
在编写bat脚本时，有一些基础语法需要记住
</br>

| 参数 | 语法解释 |
| :--- | :--- |
|@echo off|不显示命令行以及当前命令行|
|echo hello|显示hello|
|pause|暂停，等待按键继续|
|rem|注释，也可以用::或%代替|
|cd aaa|进入aaa目录|


# 特殊一点的命令
现在来讲一些bat文件中比较高级的命令，如果你学会了，那你就是就是小孩堆里的king了！这些命令主要有以下几个，我们依次讲解一下

| 参数 | 语法解释 |
| :--- | :--- |
|if|IF [NOT] string1==string2 command </br> IF [NOT] ERRORLEVEL number command </br> IF [NOT] EXIST filename command|
|goto|goto Lable 会跳转到Lable标签|
|call|调用其他bat文件或者调用标签|
|choice||
|for||
|set||

## if-else命令
if-else是条件判断语句用来判断条件是否符合，然后执行相对应的语句，主要有三种使用情况：
1. if [not] "参数" == "字符串" 待执行的命令，只要相等，则运行命令，否则依次运行下面的else语句，如果没有else语句就会跳出此if判断语句，继续向下运行。
 
例：
```
@echo off
chcp 65001>nul & :: 强制命令指示符使用utf-8编码，不然中文会乱码

set /p pwd=请输入密码: & :: 将用户输入的密码赋值到pwd

if "%pwd%" == "123" (
    echo 密码正确
    pause % 防止输出后闪退 %
) else (  
    % 注意else和(之间有空格 %
    echo 密码错误
    pause
)
```
[下载示例](/download/bat/if_pwd.bat)

## goto 


