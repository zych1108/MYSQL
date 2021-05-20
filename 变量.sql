#变量
/*
系统变量：
       全局变量
       会话变量
自定义变量：
	用户变量
	局部变量 

*/
#一、系统变量
/*
说明：变量由系统提供，不是用户定义，属于服务器层面
使用的语法：
1、查看所有的系统变量
show global 【session】 variables;
2、查看满足条件的部分系统变量
show global【session】variables like '%char%';
3、查看指定的某个系统变量的值
select @@global【session】.系统变量名;
4、为某个系统变量赋值
方式一：
set global【session】 系统变量名=值;
方式二：
set @@global【session】.系统变量名=值；

*/

#1.全局变量
/*
作用域：服务器每次启动将为所有的全局变量赋初始值，针对所有的会话（连接）有效，但不能跨重启。
*/
#查看所有的全局变量
SHOW GLOBAL VARIABLES;
#查看部分的全局变量
SHOW GLOBAL VARIABLES LIKE '%char%';
#查看指定的全局变量的值
SELECT @@global.autocommit;
#为某个指定的全局变量赋值
SET @@global.autommit=0;

#会话变量
/*
作用域：仅仅针对当前的会话（连接）有效
*/
#查看所有的会话变量
SHOW SESSION VARIABLES;
SHOW  VARIABLES;
#查看部分的会话变量
SHOW  VARIABLES LIKE '%char%';
#查看指定的耨个会话变量
SELECT @@session.tx_isolation;
#为某个会话变量赋值
方式一：
SET @@session.tx_isolation='read-uncommitted';
方式二：
SET SESSION tx_isolation ='read-committed';

二、自定义变量
/*
说明：变量是用户自定义的不是由系统的
使用步骤：
声明
赋值
使用（查看、比较、运算等）

*/
#1、用户变量
/*
作用域：针对于当前会话有效
应用在任何地方，也就是begin end里面或外面
*/
#声明并初始化
SET @用户变量名=值;或
SET @用户变量名:=值;或
SELECT @用户变量名:=值;

#赋值
方式一：同1
SET @用户变量名=值;或
SET @用户变量名:=值;或
SELECT @用户变量名:=值;
方式二：
通过SELECT INTO 
SELECT 字段 INTO 变量名 FROM 表；

#查看
SELECT @用户变量名

#案例：
#声明
SET @count=1;
#赋值
SELECT COUNT(*) INTO @count FROM employees;
#查看
SELECT @count;


#2.局部变量
/*
作用域：仅仅在定义他的begin end 中有效
应用在begin end 中的第一句
*/
#声明
DECLARE 变量名 类型;
DECLARE 变量名 类型 DEFAULT 值;

#赋值
方式一：同1
SET 局部变量名=值;或
SET 局部变量名:=值;或
SELECT 局部变量名:=值;
方式二：
通过SELECT INTO 
SELECT 字段 INTO 变量名 FROM 表；

#使用
SELECT 局部变量名;

                作用域           定义和使用的位置           语法
用户变量        当前会话          会话的任何地方            必须加@符号

局部变量        BEGIN END中       只能在BEGIN END中          一般不用@ 需要限定类型

#案例：声明两个变量并赋初值，求和，并打印
#1用户变量
SET @m=1;
SET @n=2;
SET @sum=@m+@n;
SELECT @sum;

#2.局部变量
DECLARE m INT DEFAULT 1;
DECLARE n INT DEFAULT 2;
DECLARE SUM INT;
SET SUM=m+n;
SELECT SUM;



