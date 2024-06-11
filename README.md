> 本仓库用于记录学习内容
> 本文件用于记录常用的命令或语法
# 语法
## Markdown
1. 文本中间插入用`shutdown -r -t 0`  
2. 行内公式$f(x)=p$  
3. 行间公式
$$
f(x)=\beta\alpha^2_n\\m
f(x)=abc.\\
x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}
$$
4. 链接[跳转到](./.笔记.md)
## shell
文件测试操作符：
-e：检查文件是否存在。
-d：检查文件是否是目录。
-f：检查文件是否是普通文件。
-r：检查文件是否可读。
-w：检查文件是否可写。
-x：检查文件是否可执行。
-s：检查文件是否非空（大小大于0）。
-z：检查字符串长度是否为0（空字符串）。
-n：检查字符串长度是否非0（非空字符串）。
字符串比较操作符：
= 或 ==：检查两个字符串是否相等。
!=：检查两个字符串是否不相等。
-z：检查字符串是否为空。
-n：检查字符串是否非空。
整数比较操作符：
-eq：检查两个整数是否相等。
-ne：检查两个整数是否不相等。
-lt：检查一个整数是否小于另一个整数。
-le：检查一个整数是否小于或等于另一个整数。
-gt：检查一个整数是否大于另一个整数。
-ge：检查一个整数是否大于或等于另一个整数。
复合比较操作符：
-a：逻辑与（AND），类似于&&。
-o：逻辑或（OR），类似于||。

## batch
```bat
::关闭命令行的回显，避免显示不必要的信息
@echo off
::使用unicode字符集
1>null chcp 65001
title 标题
::第一个数字为文字颜色，第二个数字为背景颜色
color 8f
::获取管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" || (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
echo 你已经获得管理员权限.

pause
```

## 正则表达式
    正则
    限定符：?, *, +, (){}
    ? 次数[0,1]，如used?表示use或used 
    * 次数[0,+∞]，如ab*c可以表示ac, abc, abbc等
    + 次数[1,+∞]，
    {} 可以指定出现多少次, a{2,6}, b{3,}, c{4}, (abc){5}
    或运算符：|
    (cat|dog) 表示cat或dog
    字符类：[]+
    表示由括号种的字符组成，如：[abc]+可以匹配到acccb, ac, b等单词 [a-zA-Z0-9]+表示所有字母数字 [^0-9]表示所有非数字
    元字符
    \d 数字
    \w 单词 （英文，数字和下划线）
    \s 空白符 （tab和换行）
    \D 非数字
    \W 非单词
    \S 非空白符
    \b是一个定位符，它表示单词的边界，也就是单词和空格或标点符号之间的位置12。例如，\bcat\b可以匹配到"The cat is cute."中的"cat"，但不能匹配到"concatenate"中的"cat"
    . 任意字符（不包括换行符）
    ^ 匹配行首 ^a表示行首的a
    $ 匹配行尾 b$表示行尾的b
    贪婪和懒惰匹配
    限定符后面加?为懒惰模式，不加为贪婪模式。懒惰模式会匹配最少的内容。比如对a321b234b进行匹配，a.*b是a321b234b，a.*?b是a321b
    
## DOT
> 一般以`.gv`或`.dot`格式保存，使用graphviz工具包生成图片：`dot -Tsvg -Kdot input.gv -o outpu.svg`或`dot -Tsvg -O input.gv`
DOT语言的基本使用流程：
```dot
digraph base_flow {
    graph[label = "基本使用流程", size = "2,3"];
    node[shape=box];
    graph_attr[label="1. 定义digraph的属性"];
    node_edge_attr[label="2. 定义node、edge的属性"];
    node_edge_added[label="3. 添加node、edge"];
    custom_attr[label="4. 定义特定node，edge的属性"];
    graph_attr -> node_edge_attr -> node_edge_added -> custom_attr;
}
```
### 图：
- graph： 1）`digraph {...}` 定义有向图；2）`graph {...}`定义无向图；
- subgraph：`subgraph {...}`定义子图；
- cluster subgraph： `subgraph cluster_xxx {...}`定义的代码块，会被当成聚集子图渲染。
- `ranksep` : 相邻层级之间的距离
- `nodesep` : 同一个层级中的相邻节点的距离，单位为英寸（=2.54 cm)。
- `rankdir`: rank的指向，如 LR (left to right) or RL，或者 TB （top to bottom） or BT;
-  `size`: 用"x,y"表示长宽

### 节点：
- `shape`属性来设置节点的形状，可以是`record`（由label内容决定）、`box`（矩形）、`circle`（圆形）、`triangle`（三角形）等。
- `label`属性的语法结构如下：
不同的字段使用`|`隔开；
字段的 portname 使用 `<...>`尖括号括起来；
在`{...}`中的内容，在水平和垂直布局之间翻转，取决于 graph 的 rankdir 属性。
```dot
digraph structs {
    node[shape=record];
    graph[rankdir=TB];

    struct1[label="<f0> left|<f1> mid&#92; dle|<f2> right"];
    struct2[label="<f0> one|<f1> two"];
    struct3[label="hello&#92;nworld |{ b |{c|<here> d|e}| f}| g | h"];
    struct1:f1 -> struct2:f0;
    struct1:f2 -> struct3:here;
}
```
- `style`属性用于修改`节点`的外观，当前，支持8种类型的 style：
`filled` : 此值指示应填充节点的内部。使用的颜色是 fillcolor 定义的，若 fillcolor 属性未定义，则使用 color 属性的颜色。对于未填充的节点，节点内部对当前图形或簇背景色的任何颜色都是透明的。请注意，点形状始终是填充的。
`invisible` : 不可见。设置此样式会导致节点根本不显示。请注意，节点仍用于布局图形。
`diagonals`: 斜线 。“斜线”样式会导致在节点多边形的顶点附近绘制小斜线。
`rounded` ：圆形的，使节点的边变得圆滑，可以作用在 record 形状上。
`dashed` ： 使节点的边变为虚线；
`dotted` ： 使节点的边变为点线；
`solid` ： 使节点的边变为直线，默认属性；
`bold` : 使节点的边线加粗。
- `port`属性是指节点连接另一个节点的线条端点位置，端口的位置有8种，分别为节点的东、南、西、北、东南、东北、西南、西北，属性的值分别为`e, s, w, n, se, ne, sw, nw`
```cpp
digraph G {
  node[shape=record]
  b[label="1|<f>2|3"]
  s -> a:e [tailport = w];//源节点为w端点指向目标的e端点
  s -> b:f:s //指向b的f端口的s端点
}
```
```dot
digraph G {
  node[shape=record]
  b[label="1|<f>2|3"]
  s -> a:e [tailport = w];//源节点为w端点指向目标的e端点
  s -> b:f:s //指向b的f端口的s端点
}
```

### 示例代码：
```cpp
// 这是一个有向图的示例
digraph G {
  // 设置图形的属性
  graph [label="Example of dot language", fontsize=20, fontcolor=blue, bgcolor=white, size="8,6", rankdir=UB];
  // 设置节点的默认属性
  node [shape=ellipse, color=red, fontname="Courier"];
  // 设置边的默认属性
  edge [style=dashed, color=green];
  // 定义节点和边
  A [label="Node A"]; // 可以单独设置节点的属性
  B [shape=box]; // 可以覆盖默认属性
  C;
  D [label="Node D", shape=diamond, color=black, fillcolor=yellow, style=filled]; // 可以使用更多的属性
  A -> B; // 使用默认的边属性
  A -> C [label="Edge A-C", dir=both]; // 可以单独设置边的属性，比如标签和方向
  B -> D [weight=2]; // 可以设置边的权重，影响布局
  C -> D [color=blue, penwidth=3]; // 可以设置边的颜色和宽度
}
```
```dot
// 定义图的名称和类型
digraph G {
  // 定义图的属性
  rankdir=LR // 图的方向从左到右
  size="8,5" // 图的大小为8*5英寸
  label="人物关系图"; // 图的标题
  graph [style=invis]; //设置图形为透明，包括背景，边框，标签
  //bgcolor="transparent"; //设置背景为透明

  labelloc="t" // 标题的位置在顶部
  fontname="Noto Sans CJK SC" // 字体为Noto Sans CJK SC
  fontsize=24 // 字号为24

  // 定义节点的属性
  node [shape = box]; // 节点的形状为矩形
  node [style = filled]; // 节点的样式为填充颜色
  node [fillcolor = white]; // 节点的默认填充颜色为白色
  node [fontname = "SimHei"]; // 节点的字体为黑体

  // 定义边的属性
  edge [fontname = "SimHei"]; // 边上的字体为黑体

  // 定义子图，用来分组显示节点
  subgraph cluster_0 {
    label = "家庭"; // 子图的标题
    style=filled; // 子图的样式为填充颜色
    color=lightgrey; // 子图的颜色为浅灰色
    node [style=filled,color=white]; // 子图中节点的样式和颜色
    a0 -> a1 -> a2 -> a3; // 子图中节点之间的连接关系
    labelloc="b"; // 子图标题的位置在底部
  }
  subgraph cluster_1 {
    node [style=filled]; // 子图中节点的样式
    b0 -> b1 -> b2; // 子图中节点之间的连接关系
    label = "工作"; // 子图的标题
    color=blue; // 子图的颜色为蓝色
    labelloc="b"; // 子图标题的位置在底部
  }

  // 定义节点，可以指定不同的属性，如标签，颜色，形状等
  a0 [label="张三"]; // 节点a0，标签为张三
  a1 [label="李四"]; // 节点a1，标签为李四
  a2 [label="王五"]; // 节点a2，标签为王五
  a3 [label="赵六"]; // 节点a3，标签为赵六
  b0 [label="刘一"]; // 节点b0，标签为刘一
  b1 [label="陈二"]; // 节点b1，标签为陈二
  b2 [label="周三"]; // 节点b2，标签为周三

  start [shape=Mdiamond]; // 开始节点，形状为菱形
  end [shape=Msquare];   // 结束节点，形状为正方形

  // 定义边，可以指定不同的属性，如标签，颜色，样式等
  start -> a0;           // 开始节点指向a0节点
  start -> b0;           // 开始节点指向b0节点
  a1 -> b3 [color=red];   // a1节点指向b3节点，边的颜色为红色 
  b2 -> a3 [style=dotted];   // b2节点指向a3节点，边的样式为虚线 
  a3 -> a0;              // a3节点指向a0节点 
  a3 -> end;             // a3节点指向结束节点 
  b3 -> end;             // b3节点指向结束节点 
/*
  struct1[label="<f0> left|<f1> mid&#92; dle|<f2> right"];
    struct2[label="<f0> one|<f1> two"];
    struct3[label="hello&#92;nworld |{ b |{c|<here> d|e}| f}| g | h"];
   a1 -> struct1:f1 -> struct2:f0;
   a1 ->  struct1:f2 -> struct3:here;
*/
}
```

## Plantuml
> 通常保存为`.puml`格式，需要用`graphviz`工具包和官方提供的`plantuml.jar`包来转换为图片：`java -jar plantuml.jar -tsvg input.puml output.svg`或`java -jar plantuml.jar -tsvg input.puml`
实例：

```puml
@startuml
'定义抽象类
abstract class Animal {
  -name: String
  +eat(): void
  +sleep(): void
}

'定义接口
interface Speakable {
  +speak(): void
}

'定义枚举
enum Gender {
  MALE
  FEMALE
}

'定义普通类
class Human {
  -name: String
  -age: int
  -gender: Gender
  +work(): void
}

'定义泛化关系（继承）
Human --|> Animal

'定义实现关系（实现接口）
Human ..|> Speakable

'定义关联关系（双向）
Human "1" -- "0..*" Animal : owns >
@enduml
@startuml
'定义对象
object lion {
  name = "Leo"
}

object tiger {
  name = "Tina"
}

object zookeeper {
  name = "Tom"
}

'定义链（连接对象）
zookeeper -- lion : feeds >
zookeeper -- tiger : feeds >
@enduml
```

## LaTex
常用的文档类型`documentclass`：
- 对于英文，可以用`book`、`article`和`beamer`；
- 对于中文，可以用`ctexbook`、`ctexart`和`ctexbeamer`，这些类型自带了对中文的支持。

常用的宏包`usepackage`：
- `geometry`:页边距
- `graphicx`:插入图片
- `hyperref`:超链接
- `amsmath`:数学公式格式
- `amssymb`:额外的数学符号
- `amsthm`:定理环境

设置局部的特殊字体：
|   字体   |    命令    |
| -------- | --------- |
| 直立      | \textup{} |
| 意大利   | \textit{} |
| 倾斜       | \textsl{} |
| 小型大写 | \textsc{} |
| 加宽加粗 | \textbf{} |

列表：
- 无序列表`itemize`
- 有序列表`enumerate`
- 描述`description`

### 定理环境

定理环境需要使用`amsthm`宏包，首先在导言区加入：

```text
\newtheorem{theorem}{定理}[section]
```

其中`{theorem}`是环境的名称，`{定理}`设置了该环境显示的名称是“定理”，`[section]`的作用是让`theorem`环境在每个section中单独编号。在正文中，用如下方式来加入一条定理：

```tex
\begin{theorem}[定理名称]
    这里是定理的内容. 
\end{theorem}
```

其中`[定理名称]`不是必须的。另外，我们还可以建立新的环境，如果要让新的环境和`theorem`环境一起计数的话，可以用如下方式：

```tex
\newtheorem{theorem}{定理}[section]
\newtheorem{definition}[theorem]{定义}
\newtheorem{lemma}[theorem]{引理}
\newtheorem{corollary}[theorem]{推论}
\newtheorem{example}[theorem]{例}
\newtheorem{proposition}[theorem]{命题}
```

另外，定理的证明可以直接用`proof`环境。

### 数学公式

- 行内公式
```tex
若$a>0$, $b>0$, 则$a+b>0$.
```
公式环境通常使用特殊的字体，并且默认为斜体。需要注意的是，只要是公式，就需要放入公式环境中。如果需要在行内公式中展现出行间公式的效果，可以在前面加入`\displaystyle`，例如
```tex
设$\displaystyle\lim_{n\to\infty}x_n=x$.
```

- 行间公式
```tex
若$a>0$, $b>0$, 则
$$
a+b>0.
$$
```

- 上下标
上标可以用`^`输入，例如`a^n`，效果为  ；下标可以用`_`来输入，例如`a_1`，效果为  。上下标只会读取第一个字符，如果上下标的内容较多的话，需要改成`^{}`或`_{}`。

- 分式
分式可以用`\dfrac{}{}`来输入，例如`\dfrac{a}{b}`，效果为  。为了在行间、分子、分母或者指数上输入较小的分式，可以改用`\frac{}{}`，例如`a^\frac{1}{n}`，效果为  。

- 括号
括号可以直接用`(..)`输入，但是需要注意的是，有时候括号内的内容高度较大，需要改用`\left(..\right)`。例如`\left(1+\dfrac{1}{n}\right)^n`，效果是  。
在中间需要隔开时，可以用`\left(..\middle|..\right)`。
另外，输入大括号{}时需要用`\{..\}`，其中`\`起到了转义作用。

- 加粗
对于加粗的公式，建议使用`bm`宏包，并且用命令`\bm{}`来加粗，这可以保留公式的斜体。

- 大括号
在这里可以使用`cases`环境，可以用于分段函数或者方程组，例如
```tex
$$
f(x)=\begin{cases}
    x, & x>0, \\
    -x, & x\leq 0.
\end{cases}
$$
```
效果为

- 多行公式
多行公式通常使用`aligned`环境，例如
```tex
$$
\begin{aligned}
a & =b+c \\
& =d+e
\end{aligned}
$$
```
效果为

- 矩阵和行列式
矩阵可以用`bmatrix`环境和`pmatrix`环境，分别为方括号和圆括号，例如
```tex
$$
\begin{bmatrix}
    a & b \\
    c & d
\end{bmatrix}
$$
```
效果为  。
如果要输入行列式的话，可以使用`vmatrix`环境，用法同上。

### 示例
```tex
% 导言区，document以前的部分。不会显示
\documentclass[12pt, a4paper, oneside]{ctexart} % 定义文档类型。设置字体12pt，A4，单面打印
\usepackage{amsmath, graphicx} % 导入宏包
\usepackage[bookmarks=true, colorlinks, citecolor=blue, linkcolor=black]{hyperref} % 超链接颜色
\usepackage{geometry}
\geometry{left=2.54cm, right=2.54cm, top=3.18cm, bottom=3.18cm} % 页边距
\linespread{1.5} %行边距
\title{文章标题 \LaTeX 文档}
\author{作者姓名}
\date{\today}

% 正文区，documnet内部
\begin{document}

\pagenumbering{gobble} % 隐藏本页页码
\maketitle

\newpage
\tableofcontents % 生成目录

\newpage
\setcounter{page}{1} %从本页开始计算页码
\pagenumbering{arabic}

\begin{abstract}
这里是摘要内容。
\end{abstract}

\section{引言}
这里是引言部分。

\section{基本格式}
本章展示各种格式。

\subsection{图表}
本节展示如何插入列表。
\begin{enumerate}
    \item[(1)] 这是第一点; 
    \item[(2)] 这是第二点;
    \item[(3)] 这是第三点. 
\end{enumerate}

\subsection{图表}
本节展示如何插入图表。
\subsubsection{图}
插入图。
\begin{figure}[h]
\centering
\includegraphics[width=0.5\textwidth]{example-image}
\caption{这里是图表的标题}
\label{fig:example}
\end{figure}
\subsubsection{表}
插入表格。
\begin{table}[htbp]
  \centering
  \caption{表格标题}
  \label{tab:label}
  \begin{tabular}{|c|c|c|}
    \hline
    表头1 & 表头2 & 表头3 \\
    \hline
    内容1 & 内容2 & 内容3 \\
    \hline
  \end{tabular}
\end{table}


\section{其他功能}
展示其他功能。
\subsection{数学公式}
这里展示如何插入数学公式。
\begin{equation}
E = mc^2
\end{equation}

\section{结论}
这里是结论部分。

\begin{thebibliography}{99}
\bibitem{ref1}
作者名. (年份). 文章标题. 期刊名称, 卷(期), 页码范围.
\end{thebibliography}

\end{document}
```

# 工具
## git
初始化
```bash
# git全局设置
git config --global user.name "yourname"
git config --global user.email "youremail@gmail.com"
git config --global --add safe.directory /opt/my-project #添加安全目录
ssh-keygen -t rsa -C "your_email@example.com" #生成ssh公钥
# 创建库
git init #创建新库，--bare参数表示不生成.git操作空间
git clone -b main git@10.0.1.11/home/git/repo1 #从远程克隆库，-b指定分支
# 先压缩再传输，取值[-1,9]，-1默认压缩库，0不压缩
git config --add core.compression 9
# 和远程仓库建立连接，origin是连接的代号，可以是任意名称
git remote add origin git@github.com:rineikou/repo1.git
git remote add -f origin http://~.git # -f参数获取远程仓库的文件和分支等信息
# 建立分支追踪关系
git branch -M master
git push -u origin master #推送到origin的master分支，没有该分支自动创建
git branch --set-upstream-to=origin/master master

# 本地创建空仓库和远程同步，最好保持本地仓库时空的
git init
git remote add origin [远程仓库连接地址] #建立本地仓库和远程仓库的连接。
git pull origin master #把远程仓库的master分支合并到当前分支。
git push origin -u master #建立分支追踪，把当前分支推送到远程仓库的master分支。
```
日常操作
```bash
# 提交到本地仓库
git add 文件名 #添加文件，用.表示全部添加，git add .
git commit 文件名 -m "提交代码备注" #提交文件
git commit -a -m "提交代码备注" #提交所有文件
# 同步到远程仓库master分支
git push -u origin master
# 提交所有文件到远程连接origin
git add .
git commit -m "提交代码备注" 
git push origin 
#push到指定分支
git branch -a #查看所有分支（绿色为本地分支，红色为远程分支）
git checkout -b dev origin/dev #在本地新建dev分支，关联远程origin/dev分支，并切换到本地的dev分支，进行开发
git add .
git commit -m ''
git push origin dev #提交新代码到远程仓库的dev分支
# 检出tag
git checkout tag_name #检出tag
git checkout -b <branch_name> <tag_name>
# 查看差异
git diff --stat master origin/master
```
其他操作 
```shell
## 添加submodule
git submodule add -b master <远程仓库地址> <本地路径>
## 拉取带有submodule的仓库
# 仓库一起拉取：
git clone --recurse-submodules 父仓库地址
# 分开拉取：
git clone 父仓库地址
git submodule init // 初始化子模块
git submodule update // 更新子模块与主仓库中的子模块代码同步
# or
git submodule update --init
# or 嵌套的(子仓库中包含子仓库)
git submodule update --init --recursive
## 更新submodule
git pull
git status
git submodule update --remote
git submodule foreach && git submodule update#有多层submodule时使用
# rebase
git pull --rebase origin master
git pull=git fetch 和 git merge
git pull --rebase =git fetch 和 git rebese
rebase会把远程的提交历史添加到本地的提交历史后面，最后再添加上本地的最后一次提交。例如原来是：
A—B—C master
D—E origin/master
合并后变成
A—B—D—E—C master
origin/master
保证了历史的线性，避免不必要的合并和提交。
```
github相关
>加速器:  
steampp.net	hosts代理模式需要443端口  
GitHub搜索:  
in:name xxx #按照项目名/仓库名搜索（大小写不敏感）  
in:readme xxx 
in:decription xxx 
pushed:>yyyy-mm-dd  
awesome xxx #找百科大全  
xxx sample #找例子  
xxx starter/xxx boilerplate #找空项目架子  
xxx tutorial #找教程  


## ftp
安装
```bash
#ftp用户禁用ssh
vim /etc/passwd   shell改为/sbin/nologin
vim /etc/shells   增加/sbin/nologin
#安装ftp,使用被动模式
yum install vsftpd -y
vim /etc/vsftpd/vsftpd.conf
```
```conf
#改
anonymous_enable=NO
#增加
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
xferlog_file=/var/log/xferlog
allow_writeable_chroot=YES
listen_port=60021
pasv_enable=YES
pasv_min_port=65400
pasv_max_port=65410
local_root=/opt/WaveFax7Data/AutoFaxDir/
userlist_deny=no
userlist_file=/etc/vsftpd/user_list
```

```bash
vim user_list #登录ftp
vim chroot_list #可以切换目录
vim ftpusers #黑名单
#设置selinux
getsebool -a|grep ftp #查看selinux中有哪些是关于ftp的
#设置all_ftpd_anon_write和allow_ftpd_full_access为on状态
setsebool -P allow_ftpd_anon_write on
setsebool -P allow_ftpd_full_access on
service vsftpd restart #重启FTP服务，即可正常传输文件。
```
## jenkins
安装
```bash
#install
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo --no-check-certificate
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo yum install java-1.8.0-openjdk
sudo yum install jenkins
#start
sudo systemctl enable jenkins
sudo systemctl start jenkins
firewall-cmd --add-ports=8080/tcp --permanent
```