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
