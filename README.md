# markdown语法
文本中间插入用单引号`shutdown -r -t 0`  
行内公式$f(x)=p$  
行间公式
$$
f(x)=\beta\alpha^2_n\\m
f(x)=abc.\\
x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}
$$
链接
[跳转到](./arch.md)
# git常用操作
```bash
#git全局设置
git config --global user.name "yourname"
git config --global user.email "youremail@gmail.com"
git config --global --add safe.directory /opt/my-project #添加安全目录
ssh-keygen -t rsa -C "your_email@example.com" #生成ssh公钥
#创建新库
git init #带--bare不生成.git操作空间
#先压缩再传输，取值[-1,9]，-1默认压缩库，0不压缩
git config --add core.compression 9
git clone -b main git@10.0.1.11/home/git/repo1 #指定main分支
```
```bash
#提交到本地仓库
git add . #或者git add xxx
git commit -m "提交代码备注" 
#或者直接添加文件并提交
git commit 文件名 -m "备注"
#没有新文件可以直接使用
git commit -a -m ''
#和远程仓库建立连接，origin是连接的代号，可以是任意名称
git remote add origin git@github.com:rineikou/repo1.git
git remote add -f origin http://~.git # 获取远程仓库的文件和分支等信息
#同步到远程仓库master分支
git push -u origin master
#添加submodule
git submodule add -b master <仓库地址> <本地路径>
#克隆带有submodule的仓库
git clone --recursive <仓库地址>
#更新submodule
git pull
git status
git submodule update --remote
git submodule foreach git submodule update#有多层submodule时使用
#push到指定分支
git branch -a #查看所有分支（绿色为本地分支，红色为远程分支）
git checkout -b dev origin/dev #在本地新建dev分支，关联远程origin/dev分支，并切换到本地的dev分支，进行开发
git add .
git commit -m ''
git push origin dev #提交新代码到远程仓库的dev分支
#检出tag
git checkout tag_name#检出tag
git checkout -b <branch_name> <tag_name>
#查看差异
git diff --stat master origin/master
```
# github相关
>加速器:  
steampp.net	hosts代理模式需要443端口  
GitHub搜索:  
in:name xxx #按照项目名/仓库名搜索（大小写不敏感）  
in:readme xxx #大小写不敏感  
in:decription xxx #大小写不敏感  
stars:>xxx  
forks:>xxx  
language:xxx  
pushed:>yyyy-mm-dd  
awesome xxx #找百科大全  
xxx sample #找例子  
xxx starter/xxx boilerplate #找空项目架子  
xxx tutorial #找教程  
例子：  
in:name spring boot stars:>1000 pushed:>2020-09-20 fork:>2000  
关键字spring boot 点赞数>1000 更新时间2020-09-20之后 拷贝人数2000  