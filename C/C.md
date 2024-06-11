> IDE:vim+gcc  或者codeblocks
```shell
# 使用gcc编译
gcc -E test.c -o test.i #预处理
gcc -S test.i -o test.s #编译成汇编语言
gcc -c test.s -o test.o #汇编成二进制文件
gcc test.o -o test #链接，生成最终的可执行二进制文件

gcc test.c -o test #自动完成上述过程，直接生成最终的可执行二进制文件

gcc test.cpp -lstdc++ #使用gcc编译cpp文件
```
