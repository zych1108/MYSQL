#存储过程和函数
/*
存储过程和函数：类似于java中的方法

*/
#存储过程
/*
含义：一组预先编译号的SQL语句的集合，理解成批处理语句。
好处：
1、提高代码的重用性
2、简化操作
3、减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率。
*/

#一、创建语法
CREATE PROCEDURE 存储过程名（参数列表）
BEGIN 
       存储过程体(一组合法的SQL语句)
       
END
注意：
1、参数列表包含三部分
参数模式    参数名      参数类型
举例：
IN stuname VARCHAR(20)

参数模式：
IN:该参数可以作为输入，也就是该参数需要调用方传入值
OUT:该参数可以作为输出，也就是该参数可以作为返回值
INOUT:该参数既可以作为输入又可以作为输出，也就是该参数既需要传入值，又可以返回值

2、如果存储过程体仅有一句话 BEGIN END 可以省略
存储过程体中的每条语句必须加分号
存储过程的结尾可以使用DELIMITER重新设置
语法：
DELIMITER 结束标记

#二、调用语法
CALL 存储过程名（实参列表）;

#空参列表
#案例：插入到admin表中的五条记录
SELECT *FROM admin;

DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
     INSERT INTO admin(username,`password`)
     VALUES('john1','0000'),('john2','0000'),('john3','0000'),('john4','0000'),('john5','0000');
END $

#调用
CALL myp1()$

#2创建带in模式参数的存储过程
#案例1：创建存储过程实现 根据女神名，查询对应的男神信息
CREATE PROCEDURE myp2(IN beautyName VARCHAR(20))
BEGIN
     SELECT bo.*
     FROM boys bo
     RIGHT JOIN beauty b ON bo.id =b.boyfriend_id
     WHERE b.name=beautyName; 
END $

CALL myp2('柳岩')$
#案例2：创建存储过程实现，用户是否登录成功
CREATE PROCEDURE myp3(IN username VARCHAR(20),IN PASSWORD VARCHAR(20))
BEGIN
      DECLARE result INT DEFAULT 0;#声明类型并初始化
      
      SELECT COUNT(*) INTO result #赋值
      FROM admin a
      WHERE a.username=username
      AND a.password=PASSWORD;

      SELECT IF(result>0,'成功','失败');#使用
END $

CALL myp3('张飞','8888')$


#3.创建带out模式的存储过程
#案例1：根据女神名，返回对应的男神名
CREATE PROCEDURE myp4(IN beautyName VARCHAR(20),OUT boyName VARCHAR(20))
BEGIN
     SELECT bo.`boyName` INTO boyName
     FROM beauty b
     LEFT JOIN boys bo
     ON b.`boyfriend_id`=bo.`id`
     WHERE b.`name`=beautyName;

END $

CALL myp4('柳岩',@bName)$

SELECT @bName$

#案例2：根据女神名，返回对应的男神名和男神的魅力值
CREATE PROCEDURE myp4(IN beautyName VARCHAR(20),OUT boyName VARCHAR(20),OUT userCP INT)
BEGIN
     SELECT bo.`boyName`,bo.userCP INTO boyName,userCP
     FROM beauty b
     LEFT JOIN boys bo
     ON b.`boyfriend_id`=bo.`id`
     WHERE b.`name`=beautyName;

END $


CALL myp6('柳岩',@bName,@usercp)$
SELECT @bName,@usercp$

#4.创建带inout 模式参数的存储过程
#案例1：传入a和b两个值，最终a和b都翻倍并返回。
CREATE PROCEDURE myp8(INOUT a INT,INOUT b INT)
BEGIN 
	SET a=a*2;
	SET b=b*2;
END $

SET @m=10$
SET @n=20$
CALL myp8(@m,@n)$
SELECT @m,@n$

#一、创建存储过程实现传入用户名和密码，插入到admin表中
CREATE PROCEDURE test_pro1(IN username VARCHAR(20),IN loginPwd VARCHAR(20))
BEGIN
	INSERT INTO admin(admin.`username`,PASSWORD)
	VALUES(username,loginpwd);
END $

CALL test_pro1('admin','0000')$
SELECT * FROM admin$

#二、创建存储过程或函数实现传入女神编号，返回女神名称和女神电话
CREATE PROCEDURE test_pro2(IN id INT,OUT beautyname VARCHAR(20),OUT pnum INT)
BEGIN
	SELECT b.name,b.`phone` INTO beautyname,pnum
	FROM beauty b
	WHERE b.`id`=id;
	
END $

CALL test_pro2(1,@a,@b)$
SELECT @a,@b$

#三、创建存储过程实现传入两个女神生日，返回大小
CREATE PROCEDURE test_pro3(IN birth1 DATETIME,IN birth2 DATETIME,OUT result INT)
BEGIN
	SELECT DATEDIFF(birth1,birth2) INTO result;
END $

CALL test_pro3('1998-1-1','1999-1-2',@result)$
SELECT @result$


##二、删除存储过程
#语法：drop procedure 存储过程名

DROP PROCEDURE `myp1`;

#三、查看存储过程的信息
SHOW CREATE PROCEDURE myp2;

#四、创建存储过程实现传入一个日期，格式化成XX年XX月XX日并返回
CREATE PROCEDURE test_pro4(IN mydate DATETIME,OUT strDate VARCHAR(50))
BEGIN 
	SELECT DATE_FORMAT(mydate,'%y年%m月%d日') INTO strDate;
END $

CALL test_pro4(NOW(),@str)$
SELECT @str $

#五、创建存储过程实现传入女神名称，返回女神 and 男神 格式的字符串
CREATE PROCEDURE test_pro5(IN bname VARCHAR(20),OUT str VARCHAR(50))
BEGIN
	SELECT CONCAT(bname,'and',IFNULL(`boyName`,'null')) INTO str
	FROM beauty b
	LEFT JOIN boys bo
	ON b.`boyfriend_id`=bo.`id`
	WHERE b.`name`=bname;
END$

CALL test_pro5('柳岩',@str)$
SELECT @str$

#六、创建存储过程或函数，根据传入的条目数或起始索引，查询beauty表的记录
CREATE PROCEDURE test_pro6(IN startindex INT,IN size INT)
BEGIN
	SELECT * FROM beauty LIMIT startindex,size;
	
END $
CALL test_pro6(3,5)$
