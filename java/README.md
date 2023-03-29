#### 基础语法

准备

idea新建：新建project, 新建module, 打开项目结构，选择sdk和语言级别

包的命名：公司域名倒着写

psvm



##### 1. 注释，标识符，关键字

```java
//单行注释	//
//多行注释	/*	*/
/*
多行注释
多行注释
多行注释
多行注释
多行注释
多行注释
*/
//javaDoc:文档注释  /** */
/**
 * @Description HelloWorld
 * @Author 我是作者
 */
abstract
    
```



##### 2.数据类型

强类型语言：所有变量必须定义后才能使用

基本类型

byte, short, int, long	1,2,4,8字节

float, double	4,8字节

char	2字节

boolean true,false

引用类型：类，接口，数组

二进制0b

八进制0

十六进制0x

尽量避免使用浮点数，使用BigDecimal 数学工具类

##### 3.类型转换

byte,short,char->int->long->float->double

强制类型转换：(类型)变量名	可能存在内存溢出，或者精度问题

自动类型转：低到高

##### 4.变量、常量

实例变量：从属于对象	

类变量：加static

常量：加final

##### 5.运算符

instantceof

##### 6.包机制、JavaDoc

```java
@auther 作者名
@version 版本号
@since 指明需要最早使用的jdk版本
@param 参数名
@return 返回值
@throws 异常抛出情况
```

```bat
javadoc -encoding utf-8 -charset utf-8 Doc.java
```

#### 流程控制

##### 1. 用户交互scanner

   io流的类，用完要关掉

   next():	会过滤空白，空格作为结束符

   nextLine():	可以输入空格

#####  2.顺序结构

   顺序结构

   if

   switch	break default

3. ##### 选择结构

4. ##### 循环结构

   ```java
   //打印乘法表
   for (int j = 1; j <= 9; j++) {
               for (int i = 1; i <= j; i++) {
                   System.out.print(j+"*"+i+"="+(j*i)+"\t");
               }
               System.out.println();
           }
   ```

   增强for循环

5. ##### break&continue

   break:	强制退出整个循环

   continue:	跳过本次循环

6. ##### 练习

   ```java
   
   ```

#### 方法

##### 1.何谓方法

##### 2.方法的定义及调用

java都是值传递

##### 3.方法重载



##### 4.命令行传参

##### 5.可变参数

不定项参数：必须在最后，三点表示

##### 6.递归

需要递归头，否则栈溢出

#### 数组

##### 数组概述

##### 数组声明创建

##### 数组使用

普通for循环

for-each循环

##### 多维数组

##### Arrays类

```java
//冒泡排序，把最大的数排到最后
public static int[] sort(int[] arrays){
    int temp=0;
    //外层循环，决定排序次数//冒泡的次数
    for(int i=0;i<arrays.length-1;i++){//最后一个数不用比，所以要减1
        //内层循环,两两比较，将大数交换位置放在后面
        for(int j=0;j<arrays.length-1-i;j++){//最后一个数不用比，减1；最后排好的数不用比，减i
            if(arrays[j]>arrays[j+1]){
                temp=arrays[j];
                arrays[j]=arrays[j+1];
                arrays[j+1]=temp;
            }
        }
    }
    return arrays;
}
```



##### 稀疏数组





