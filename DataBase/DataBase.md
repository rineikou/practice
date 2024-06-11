crud

DDL	数据库定义语言

操作数据库>操作数据库中的表>操作数据库中表的数据

DML	操作

DQL	查询

DCL	控制

列类型

int			标准整数

decimal	字符串形式的浮点数	金融常用

varchar	可变字符串	0-65535	常用的string

text			文本串		2^16-1	保存大文本

datetime	YYYY-MM-DD HH:mm:ss	

timestamp	时间戳，1970.1.1到现在的毫秒数

null	不要使用null进行运算，结果为null

字段属性（重点）

unsigned

无符号的整数，声明该列不能为负数

zerofill

0填充的，不足的位数使用零填充

自增

自动在上一条记录的基础上+1（默认），通常用来设计唯一的主键，必须是整数类型，可以自定义设置主键自增的起始值和步长

非空

默认



> id	主键
> `version` 乐观锁
> is_delete	伪删除
> gmt_create	创建时间
> gmt_update	修改时间


超级管理员sys / change_on_install
普通管理员system / manager
普通用户scott / tiger
大数据用户（样本数据库）sh / sh
### mysql

#### 安装windows版

```bat
#使用压缩包，不用exe，解压
#配置环境变量，把bin目录添加到path变量
#新建mysql配置文件ini（my.ini)
#
[mysqld]
basedir=D:\mysql\
datadir=D:\mysql\data\
port=3306
skip-grant-tables #表示跳过密码
#管理员cmd，进入bin目录
mysqld -install #安装服务
mysqld --initialize-insecure --user=mysql #初始化数据文件
mysql -u root -p 
update mysql.user set authentication_string=password('123456') where user='root' and Host='localhost'; #更改root权限
flush privileges; --刷新权限
#删除my.ini文件里最后一句skip-grant-tables

mysql -u root -p
mysql>use mysql;
mysql>update user set host = '%' where user = 'root'  and host='localhost';
mysql>select host, user from user;
flush privileges;

```

#### mysql常用命令

```sql
create database if not exists ;
drop database if exists ;
use `数据库名` --切换数据库
update mysql.user set authentication_string=password('123456') where user='root' and Host='localhost'; --修改root用户密码，host='%'表示所有主机
flush privileges; --刷新权限
show database; 
show tables; --查看所有表
describe 数据库名; --显示数据库中所有表的信息
create database 数据库名：

```
### Oracle

#### Oracle11g安装

```bash
#创建用户oracle:dba
groupadd dba
useradd -g dba oracle
#安装依赖
wget http://vault.centos.org/5.11/os/x86_64/CentOS/pdksh-5.2.14-37.el5_8.1.x86_64.rpm
rpm -ivh pdksh-5.2.14-37.el5_8.1.x86_64.rpm
yum install -y gcc libaio glibc.i686 compat-libstdc++-33 compat-libstdc++-33.i686 elfutils-libelf-devel glibc-devel glibc-headers gcc-c++ libaio-devel libaio-devel.i686 libgcc.x86_64 libgcc.i686 libstdc++ libstdc++.i686 unixODBC unixODBC.i686 unixODBC-devel unixODBC-devel.i686
#安装rlwrap，上https://centos.pkgs.org找
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/r/rlwrap-0.45.2-1.el7.x86_64.rpm
yum install python3 -y
yum install perl-File-Slurp -y
rpm -ivh rlwrap-0.45.2-1.el7.x86_64.rpm
#上传文件oracle安装包,字体文件zysong.tff
#设置字体
mkdir -p /usr/share/fonts/zh_CN/TrueType
cp zysong.ttf /usr/share/fonts/zh_CN/TrueType/
#安装Oracle，有报错按照提示解决
vim .bash_profile #添加环境变量
source .bash_profile #或. .bash_profile
#监听自启动 参考https://blog.csdn.net/wqh0830/article/details/87855854
#导出
expdp olduser/123456@localhost/orcl directory=dbdir dumpfile=olduser.dmp logfile=exp_olduser.log schemas=olduser
#导入
impdp u_test/123456@localhost/orcl directory=dbdir dumpfile=olduser.dmp logfile=imp_test.log remap_schema=olduser:u_test schemas=olduser table_exists_action=replace
```

```bash
#/home/oracle/.bash_profile添加内容
ORACLE_BASE=$HOME/app/oracle
ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
ORACLE_SID=wavefax
NLS_LANG='SIMPLIFIED CHINESE_CHINA.AL32UTF8'
PATH=$PATH:$HOME/.local/bin:$HOME/bin:$ORACLE_HOME/bin
export ORACLE_BASE ORACLE_HOME ORACLE_SID NLS_LANG PATH
alias sqlplus='rlwrap sqlplus'
alias rman='rlwrap rman'
alias lsnrctl='rlwrap lsnrctl'
```

#### Oracle常用命令

```sql
--sqlplus保存操作日志
spool /data/log.log;
spool off;
--创建目录
--create directory dbdir as '~/dbdir';
--create or replace directory dbdir as '~/dbdir';
--创建临时表空间
create temporary tablespace ts_test_temp  
tempfile '$ORACLE_BASE/oradata/orcl/ts_test_temp.dbf' 
size 128m
autoextend on
next 16m
maxsize 20480m
extent management local;
--创建数据表空间
create tablespace ts_test
logging  
datafile '$ORACLE_BASE/oradata/orcl/ts_test.dbf' 
size 128m
autoextend on
next 16m
maxsize 20480m
extent management local;
--创建用户并指定表空间
create user u_test identified by 123456
default tablespace ts_test
temporary tablespace ts_test_temp;
--给用户授予权限
grant connect,resource,dba to u_test;
grant exp_full_database to u_test;
grant imp_full_database to u_test;
grant read,write on directory dbdir to u_test;
--查看当前库
show parameter name
--数据库字符集
select * from v$nls_parameters where parameter = 'NLS_CHARACTERSET';
select * from nls_database_parameters;
--删除用户，先删用户，再删除表空间
drop user u_test cascade;
drop tablespace ts_test including contents and datafiles;
drop tablespace ts_test_temp including contents and datafiles;
--修改内存(Windows版本会占用内存)
show parameter name
show parameter sga
show parameter target
alter system set sga_max_size=12288M scope=spfile;
alter system set sga_target=12288M scope=spfile;
alter system set pga_aggregate_target=4096M scope=spfile;
shutdown immediate;
startup;
```

### postgresql备份
```bash
pg_dump -U postgres -f D:\dump220222.dmp db_greatwallfund
psql db_greatwallfund<D:\dump220222.dmp postgres
```