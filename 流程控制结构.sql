#流程控制结构
/*
顺序结构：
分支结构：程序从两条或多条路径中选择一条去执行
循环结构：程序在满足一定条件的基础上，去复制执行一段代码

*/
#一、分支结构
#1.if函数
/*
功能：实现简单的双分支
语法：
If(表达式1，表达式2，表达式3)
执行顺序：
如果表达式1成立，则if函数返回表达式2的值，否则返回表达式3的值
应用：任何地方
*/
#2.case结构
情况1：类似于java中的switch语句，一般用于实现等值判断
语法：
     CASE 变量|表达式|字段
     WHEN 要判断的值 THEN 返回的值1或语句1；
     WHEN 要判断的值 THEN 返回的值2或语句2
     ...
     ELSE 要返回的值n或语句n；
     END CASE;
情况2：类似于java中的多重IF语句，一般用于实现区间判断
语法：
     CASE 
     WHEN 要判断的值 THEN 返回的值1
     WHEN 要判断的值 THEN 返回的值2
     ...
     ELSE 要返回的值n
     END
     
/*
特点:
可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，begin end 中或begin end 的外面
可以作为独立的语句去使用，只能放在begin end中     
  
 如果when中的值满足或条件成立，则执行对应的then后面的语句，并且结束case
 如果都不满足，则执行else中的语句或值
 
 else可以省略，如果省略了，并且所有的when条件都不满足，则返回null
 */   
 
 
#案例
#创建存储过程，根据传入的成绩，来显示等级，比如传入的成绩：90-100，显示A，80-90，显示B，60-80，显示c，否则，显示D
DELIMITER $
CREATE PROCEDURE test_case(IN score INT) 
BEGIN
	CASE
	WHEN score>=90 AND score<=100 THEN SELECT 'A';
	WHEN score>=80 THEN SELECT 'B';
	WHEN score>=60 THEN SELECT 'C';
	ELSE SELECT 'D';
	END CASE;
	
 END $
 
 CALL test_case(95)$
 
 
 #3 if 结构
 /*
功能：实现多重分支
语法：
if 条件1 then 语句1；
elseif 条件2 then 语句2；
...
【else 语句n;】 
end if;

应用在begin end中
 
 */

#案例1： 根据传入的成绩，来显示等级，比如传入的成绩：90-100，:返回A，80-90，返回B，60-80，返回c，否则，返回D
CREATE FUNCTION test_if(score INT) RETURNS CHAR
BEGIN
	IF score>=90 AND score<=100 THEN RETURN 'A';
	ELSEIF score>=80 THEN RETURN 'B';
	ELSEIF score>=60 THEN RETURN 'C';
	ELSE RETURN 'D';
	END IF;
END$
SELECT test_if(89)$

#二、循环结构
/*
分类：
while\loop\repeat

循环控制：
iterate类似于continue 
leave类似于 break
*/
#1 while
/*
语法：
【标签:】while 循环条件 do
         循环体;
 end while 【标签】;
 
*/
#2.loop
/*
语法：
【标签：】loop
        循环体；
 end loop 【标签】;
 
 可以用来模拟死循环

*/
#3 repeat
/*
语法：
【标签：】repeat
       循环体；
 until 结束循环的条件
 end repeat 【标签】；

*/
#案例：批量插入，更加次数插入到admin表中多条记录
CREATE PROCEDURE pro_while1(IN inserCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	WHILE i<=inserCount DO
		INSERT INTO admin(username,`password`) VALUES(CONCAT('Rose',i),'666');
		SET i=i+1;
	END WHILE;
END $
CALL pro_while1(100)$

#案例2：#案例：批量插入，更加次数插入到admin表中多条记录，如果次数>20则停止
TRUNCATE TABLE admin$
CREATE PROCEDURE pro_while2(IN inserCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	a:WHILE i<=inserCount DO
		INSERT INTO admin(username,`password`) VALUES(CONCAT('xiao',i),'666');
		IF i>=20 THEN LEAVE a;
		END IF;
		SET i=i+1;
	END WHILE a;
END $
CALL pro_while2(100)$

#3.添加iterate语句

#案例3：批量插入，更加次数插入到admin表中多条记录，只插入偶数次
TRUNCATE TABLE admin$
CREATE PROCEDURE pro_while3(IN inserCount INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	a:WHILE i<=inserCount DO
	        SET i=i+1;
	        IF i%2!=0 THEN ITERATE a;
	        END IF;
		INSERT INTO admin(username,`password`) VALUES(CONCAT('xiao',i),'666');
	END WHILE a;
END $
CALL pro_while3(100)$

##经典案例
/*
一、已知表stringcontent
其中字段：
id 自增长
content varchar(20)

向表中插入指定个数，随机的字符串
*/

DROP TABLE IF EXISTS stringcontent;
CREATE TABLE stringcontent(
	id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(20)
);

DELIMITER $
CREATE PROCEDURE test_randstr_insert(IN inserCount INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE str VARCHAR(26) DEFAULT 'zxcvbnmlkjhgfdsaqwertyuiop';
	DECLARE startIndex INT DEFAULT 1;#代表起始索引
	DECLARE len INT DEFAULT 1;#代表截取的字符的长度
	WHILE i<inserCount DO
		SET len=FLOOR(RAND()*(20-startIndex+1)+1); #产生一个随机整数，代表截取的长度，1到（26-startIndex+1）
	        SET startIndex=FLOOR(RAND()*26+1);#产生一个随机整数，代表起始索引1——26
		INSERT INTO stringcontent(content) VALUES(SUBSTR(str,startIndex,len));
		SET i=i+1;
	END WHILE;
END $

CALL test_randstr_insert(10)$

SELECT * FROM stringcontent$