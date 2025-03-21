---
title: 如何将github page同步部署到服务器上
date: 2025-03-03 14:05:53
tags: 博客入门
cover: /image/rookie_3/acg.gy_43.webp
---

# 前言
上一篇讲到了如何把本地的hexo部署到gihub上，来实现通过*github page*来作为你“服务器”，来构建你的网站，这种做法不需要花钱，算是比较经济的做法了，但是存在一个问题，就是国内的朋友们无法访问你的网站，或者是访问网站无法加载图片（该死的github还是跨不过那堵墙，要么就是延迟爆高），所以今天的教学是如何将网站部署到你自己购买的服务器上

>原理很简单，通过在你的服务器上构建一个git仓库, 将本地的hexo的_config.yml配置到你的服务器git仓库就搞定了，现在我们来进行实操

# 创建你的服务器
我的服务器是在阿里云买的轻量服务器，2核2g（其实可以配置更低一点，内存可以缩到500m或者1g，这个取决你的网站有多少人访问），有新用户优惠的话一个月大概10块钱左右，如果你是富哥，你买个ecs服务器，或者更牛逼一点，无所谓！有钱就好！

## 安装宝塔面板
> 这个东西我真的强烈推荐，可以以图形化的页面来对服务器各项设置进行修改，

先放一个宝塔面板的[下载连接](https://www.bt.cn/new/download.html)，推荐避免使用最新的版本，以免出现各种各样的bug，由于bug较新，网上很难找到合适的解决方案，我这里使用的是*9.5.0*的稳定版

首先打开ssh，输入
```
if [ -f /usr/bin/curl ];then curl -sSO https://download.bt.cn/install/install_latest.sh;else wget -O install_latest.sh https://download.bt.cn/install/install_latest.sh;fi;bash install_latest.sh ed8484bec
```

宝塔面板会自动安装到你的服务器上，耐心等待大概2分钟左右，直到最后显示
![](/image/rookie_3/p517416.webp)
可以看到你的宝塔面板的账号密码，复制外网面板网址进入宝塔面板，登录进入宝塔面板

