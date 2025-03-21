---
title: 创建博客入门第二篇
date: 2025-03-01 19:43:06
tags: 博客入门
cover: /image/acg.gy_17.webp
---

# 写在开头
这篇博客用来补充前篇，把hexo部署到本地以及上传到github的步骤和踩的一些坑开一篇讲一下。也害怕自己忘了（谁知道会不会哪天自己删库重来结果建不起来了）。
言归正传，现在来讲一下。

# 本地部分

## 前置要求
保证你的电脑里已经下载了 [git](https://git-scm.com/downloads) 以及  [Node.js](https://nodejs.org/en/download)
>这里的第一个坑就是一定要注意Node.js的版本问题,推荐使用16或18版本的，我这里用的是18版本的（为什么有最新版本不用呢？亲测新版本有各种bug，最严重的问题就是没办法把你的博客push到github或你的服务器上）

![](/image/rookie_2/nodejs.webp)

安装后进入cmd输入,
```
git version
node version
```
如果正常显示版本号，证明前置要求你已经完成了！

## 安装hexo
保持在cmd的界面
1. 下载hexo的包
```
npm install -g hexo-cli
```
</br>

2. 初始化hexo，这一步看一下你想在哪个位置创建hexo，hexo初始化后会在你当前路径下生成一个文件夹，这就是hexo的根目录，我这里的文件夹叫 blog （必须保证初始化位置和node和git在同一个文件夹下）
```
hexo init <blog> #初始化，blog为任意一个你想要的文件夹名称
```
>新建完成后，指定文件夹目录下有：
node_modules: 依赖包
public：存放生成的页面
scaffolds：生成文章的一些模板
source：用来存放你的文章
themes：主题
_config.yml: 博客的配置文件

3. 测试hexo是否安装成功，输入
```
cd <blog> #以后所有有关hexo的指令都需要在blog文件夹中执行
hexo s #本地启动hexo
```
</br>

打开下面的链接
![](/image/rookie_2/hexo_s.webp)
</br>

出现下图的界面则为成功
![](/image/rookie_2/localhost.webp)
</br>
这是最初始的界面，下面我们来把他部署到github上

4. 如果想换一个好看的主题（肯定会换），进入[hexo themes](https://hexo.io/themes/)界面，选一个好看的按照教程安装就行，这里就不过多赘述。

# 云端部分

## 将hexo部署到Github上
1. 创建一个存放hexo文件的github仓库
>首先需要有一个github账号。登上账号后，点击最上面的+号，选择new repository, 仓库名为xxxx.github.io(xxxx为你的github用户名)，这有这样下面要部署到github上时才会被识别。

![](/image/rookie_2/new_repository.webp)
![](/image/rookie_2/new_repository2.webp)
</br>

2. 修改git配置文件
>设置上传免密登录

    1. 打开cmd窗口，执行如下命令：
    ```
    git config --global user.name "yourname"
    git config --global user.email "youremail"
    ```
    yourname为你github用户名，youremail为你github的邮箱。
    如果输错可以检查
    ```
    git config user.name
    git config user.email
    ```
    </br>

    2.绑定密钥
    生成本地密钥，在cmd中输入：
    ```
    ssh-keygen -t rsa -C "youremail"
    ```
    疯狂敲回车，最后会显示下图，就代表你的密钥生成成功
    ![](/image/rookie_2/ssh.webp)
    接着我们就会发现在我们的user目录下多了一个.ssh目录，打开后有一个公钥，一个私钥。id_rsa.pub是公钥，我们需要打开它，复制里面的全部内容。

    然后进入github，点击setting，找到左边的SSH and GPG keys，点击右上的New SSH key，将刚刚的密钥复制进去保存，随便起个title就行。
    ![](/image/rookie_2/setting.webp)
    ![](/image/rookie_2/ssh_setting.webp)
    </br>

    3.进行部署

    >将你本地的hexo和你的github关联起来
    复制你的github库连接

    ![](/image/rookie_2/git_link.webp)

    打开hexo根目录，找到_config.yml文件，打开翻到最后，找到**deploy**那一项，改为下列样式
    ```
    deploy:
        type: git
        repo: 刚刚复制的链接
        branch: main
    ```

    安装deploy-git ，也就是部署的命令,这样你才能用命令部署到GitHub。
    ```
    npm install hexo-deployer-git --save
    ```

    然后以此执行以下命令
    ```
    hexo c   #清除缓存文件 db.json 和已生成的静态文件 public
    hexo g       #生成网站静态文件到默认设置的 public 文件夹(hexo generate 的缩写)
    hexo d       #自动生成网站静态文件，并部署到设定的仓库(hexo deploy 的缩写)
    ```
    最后会显示
    ![](/image/rookie_2/git_success.webp)

    **查看自己的github仓库，如果有内容则代表上传成功**

    最后在网页上输入"username".github.io访问你的博客吧！






