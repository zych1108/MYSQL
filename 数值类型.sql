#常见的数据类型
/*
数值型：
    整型
    小数：
           定点数
           浮点数
    字符型：
           较短的文本：char\varchar
           较长的文本：text、blob
    日期型

*/

#一、整型
/*
分类：

tinyint、smallint、mediumint、int|integer、bigint
特点：
1、如果不设置无符号还是有符号，默认是有符号。如果想设置无符号，需要添加unsigned关键字
2、如果超出范围，会报警告，并且插入临界值
3、如果不设置长度会有默认的长度，加括号的长度表示显示的宽度。
    用zerofill可以在不够长度的时候用0左填充
*/
#1.如何设置无符号和有符号（支不支持负数）
DROP TABLE IF EXISTS tab_int;
CREATE DATABASE test;
CREATE TABLE tab_int(
	t1 INT,
	t2 INT UNSIGNED	

);
DESC tab_int;
INSERT INTO tab_int
VALUES(228282888100,100);

#二、小数
/*
1、浮点型
float(M,D)
double(M,D)
2、定点型
dec(M,D)
decimal(M,D)
特点：
1.M和D
1、
M：整数部位+小数部位
D：小数部位
2、M和D都可以省略
如果是decimal，则默认为(10,0)

3、定点型的精度较高，如果要求插入的数值的精度较高如货币运算则考虑使用
*/
CREATE TABLE tab_float(
	f1 FLOAT(5,2)
	f2 DOUBLE(5,2)
	f3 DECIMAL(5,2)

)

#原则：
/*
所选择的类型越简单越好，能保证的数值的类型越小越好
*/

#三、字符型
/*
较短的文本：
char
varchar
较长的文本：
text
blob

特点：
              写法               M                                        特点                空间的耗费         效率
char         vhar(M)        最大的字符数，可以省略，默认为1          固定长度的字符           比较耗费            高
varchar     varchar(M)      最大的字符数，不可省略                   可变长度的字符           比较节省            低 

Enum 枚举型

set 集合型
*/
CREATE TABLE tab_enum(
		c1 ENUM('a','b','c')
);
INSERT INTO tab_enumm VALUES('a');
INSERT INTO tab_enum VALUES('b');
INSERT INTO tab_enum VALUES('m');

SELECT * FROM tab_enum;

SELECT * FROM tab_set;
CREATE TABLE tab_set(
		c1 SET('a','b','c')
);
INSERT INTO tab_set VALUES('a');
INSERT INTO tab_set VALUES('a,b');
INSERT INTO tab_set VALUES('m');

#日期型
/*
分类：
date只保存日期
time只保存时间
year只保存年

datetime 保存日期+时间
timestamp保存日期+时间
特点：
                   字节              范围            时区等的影响
datetime            8               1000-9999          不受
timestamp           4               1970-2038          受
*/
CREATE TABLE tab_date(
	t1 DATETIME,
	t2 TIMESTAMP
);
INSERT INTO tab_date VALUES(NOW(),NOW());

SELECT * FROM tab_date;

SHOW VARIABLES LIKE 'time_zone';

SET time_zone='+9:00';


















