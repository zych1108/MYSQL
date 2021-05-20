#函数
/*
含义：和存储过程一致

区别：
存储过程可以有0个返回，也可以有多个返回，适合批量的插入，批量的更新
函数：有且仅有1个返回。适合处理数据后返回一个结果。
*/
#一、创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN
	函数体
END
/*
注意：
1.参数列表 包含两部分：
参数名 参数类型

2.函数体：肯定会有return语句，如果没有会报错

return值；
3.函数体中仅有一句话，则可以省略begin end
4.使用delimiter语句设置结束标记
*/

#二、调用语法
SELECT 函数名(参数列表)

#案例-----
#1.无参有返回
#案例：返回公司的员工个数
SET GLOBAL log_bin_trust_function_creators=1;
DROP FUNCTION myf1();
DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	DECLARE c INT DEFAULT 0;
	SELECT COUNT(*) INTO c
	FROM employees;
	RETURN c;
END $
SELECT myf1()$

#2.有参有返回
#案例1 根据员工名返回工资
CREATE FUNCTION myf2(empname VARCHAR(20)) RETURNS DOUBLE
BEGIN
	DECLARE c DOUBLE DEFAULT 1.1;
	
	SELECT `salary` 
	FROM employees e
	WHERE e.`last_name`='k_ing';
	RETURN c;
END $
SELECT myf2('k_ing')$

#案例2：根据部门名，返回该部门的平均工资
CREATE FUNCTION myf3(dname VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @sal=0;# 用户变量
	
	SELECT AVG(e.`salary`) INTO @sal
	FROM employees e
	INNER JOIN departments 
	ON e.`department_id`=departments.`department_id`
	GROUP BY departments.`department_id`
	HAVING `department_name`=dname;
	RETURN @sal
END$
SELECT myf3('IT')$

CREATE FUNCTION myf3(dname VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @sal=0;
	SELECT AVG(`salary`) INTO @sal
	FROM employees e
	INNER JOIN departments d
	ON e.`department_id`=d.`department_id`
	WHERE d.`department_name`=dname;
	RETURN @sal;
END$
SELECT myf3('IT')$


#三、查看函数
SHOW CREATE FUNCTION myf3;

#四、删除函数
DROP FUNCTION myf3;

#案例
#一、创建函数，实现传入两个float,返回二者之和。
CREATE FUNCTION test_fun1(num1 FLOAT,num2 FLOAT) RETURNS FLOAT
BEGIN
	DECLARE SUM FLOAT DEFAULT 0;
	SET SUM=num1+num2;
	RETURN SUM;
END $
SELECT test_fun1(1,2)$

