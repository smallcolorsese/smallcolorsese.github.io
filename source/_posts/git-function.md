---
title: git函数使用说明
date: 2025-03-11 18:13:56
tags: 函数使用
cover: /image/git_functions/acg.gy_16.jpg
---

# 前言
因为经常需要使用git把代码打包上传，经常忘记git的指令，所以就来写一章来介绍一下git相关的指令

## git创建仓库
- git init : 初始化一个仓库
- git clone ： clone 一个仓库

下面对这两种方法进行详细介绍
1. git init
    打开cmd，或者鼠标右键打开git bash here 输入
    ```
    git init
    ```
    git init会默认在当前目录下创建一个git仓库，执行完git init命令后，会生成一个.git目录，该目录包含了资源数据
    > 具体数据解析请参考https://xiaowenxia.github.io/git-inside/2021/02/16/git-layout/index.html

    如果需要在指定目录下生成仓库，则指令如下
    ```
    git init xxx(your dir)
    ```
    创建完仓库后，则会默认为你的仓库生成一个master分支（也可能是main分支，这取决于你的git版本），这个分支需要与你的github上的分支所对应

2. git clone
    使用git clone可以将你网上git仓库的数据拷贝到本地，格式为：
    ```
    git clone <url> [dir]
    ```
    url为你的仓库地址（支持不同的协议，如ssh, git, https, 最常用的是ssh协议）
    dir为在你的指定目录下生成，如果为空，则默认为在当前目录下clone

# git基本指令
- git config：配置信息
- git add： 添加文件到缓存命令
- git status： 查看文件的状态（查看是否有修改过的文件）
