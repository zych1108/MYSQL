 #常见约束
/*
含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确性和可靠性
分类：六大约束
        not null 非空，用于保证该字段的值不能为空
        DEFAULT：默认，用于保证该字段有默认值
        PRIMARY KEY ：主键，由于保证该字段的值具有唯一性，且非空
        UNIQUE：唯一性，但可以为空
        CHECK：检查约束【MYSQL中不支持】
        FOREIGN KEY:外键，由于限制两个表的关系，用于保证该字段的值必须来自于主表的关联列的值
               在从表添加外键约束，用于引用主表中某列的值
添加约束的时机
   1.创建表时
   2.修改表时
   
约束的添加分类：
   列级约束：
         六大约束语法上都支持，但外键约束没有效果
         
   表级约束：
         除了非空、默认，其他的都支持

主键和唯一的对比
               唯一性         是否可以空      一个表中可以有多少个        是否允许组合  
    主键         有               否                一个                       是

    唯一         有               是                多个                       是

组合主键 两个字段同时重复才报错

外键：
    1、要求在从表设置外键关系
    2、从表的外键列的类型和主表的关联列的类型要求一致或兼容，名称无要求
    3、主表中的关联列必须是一个key（一般是主键或唯一键）
    4、插入数据时，先插入主表，在插入从表
       删除数据时，先删除从表，在删除主表
*/ 
 
 CREATE TABLE 表名(
        字段名 字段类型 约束
        表级约束
 ) 
#一、创建表时添加约束
#1添加列级约束
/*
语法：
直接在字段名和类型后面追加约束类型即可
支持：除了check 和外键

*/


USE student;
CREATE TABLE stuinfo(
	id INT PRIMARY KEY,#主键
	stuName VARCHAR(20) NOT NULL,#非空
	gender CHAR(1) CHECK(gender='男' OR gender='女'),#检查
	seat INT UNIQUE,#唯一
	age INT DEFAULT 18,#默认约束
	majorID INT REFERENCES major(id)#外键   没有效果
); 
 
CREATE TABLE major(
	id INT PRIMARY KEY,
	majorName VARCHAR(20)
); 
DESC stuinfo;

#查看stuinfo表中的所有的索引，包括主键、外键、唯一
SHOW INDEX FROM stuinfo;
 
#2.表级约束
/*
语法：在各个字段的最下面
【constraint 约束名】  约束类型（字段名）
*/


DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	stuname VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT,
	
	CONSTRAINT pk PRIMARY KEY(id),
	CONSTRAINT uq UNIQUE(seat),
	CONSTRAINT ck CHECK(gender='男' OR gender='女'), #不支持
	CONSTRAINT fk FOREIGN KEY(majorid) REFERENCES major(id)  #不支持

); 
 
 #通用的写法
 CREATE TABLE IF NOT EXISTS stuinfo(
 	id INT,
	stuname VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(majorid)
 );
 
#二、修改表时添加约束
/*
1、添加列级约束
alter table 表名 modify column 字段名 字段类型 新约束；
2、添加表级约束
alter table 表名 add 【constraint 约束名】 约束类型（字段名）【外键的引用】；

*/


#1.添加非空约束 
 ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NOT NULL
#2.添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;
#3.添加主键
#列级约束
ALTER TABLE stunifo MODIFY COLUMN id INT PRIMARY KEY;
#表级约束
ALTER TABLE stunifo ADD PRIMARY KEY(id);
#4.添加唯一
#1列级约束
ALTER stuinfo MODIFY COLUMN seat INT UNIQUE;
#2表级约束
ALTER TABLE stunifo ADD UNIQUE(seat); 
 
#5 添加外键
ALTER TABLE stunifo ADD FOREIGN KEY(majorid) REFERENCES major(majorid)
 
#三、修改表时删除约束
#1.删除非空约束
ALTER TABLE stunifo MODIFY COLUMN stuname VARCHAR(20) NULL;
#2.删除默认约束
ALTER TABLE stunifo MODIFY COLUMN age INT;
#3.删除主键
ALTER TABLE stunifo DROP PRIMARY KEY;
#4.删除唯一
ALTER TABLE stunifo DROP INDEX seat;

#5删除外键
ALTER TABLE stunifo DROP FOREIGN KEY fk_stuinfo_major;

#标识列
/*
又称为自增长列
含义：可以不用手动的插入值，系统提供默认的序列值
特点：
 1、标识列必须和主键搭配吗？不一定，但必须是一个键
 2、一个表只能有一个标识列
 3、标识列的类型只能是数值型
 4、标识列可以通过 SET auto_increment_increment=3，设置步长。
    可以通过 手动插入值设置起始值。
*/
#一、创建表时设置标识列
DROP TABLE IF EXISTS tab_identity;
CREATE TABLE tab_identity(
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(20)
);
TRUNCATE TABLE tab_identity;
INSERT INTO tab_identity VALUES(NULL,'join')
SELECT * FROM tab_identity;

SET auto_increment_increment=3;

#二、修改表时设置标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;
#三、删除标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT ;





 