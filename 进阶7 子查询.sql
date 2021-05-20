#进阶7：子查询
/*
含义：出现在其他语句中的select语句，称为子查询或内查询

外部的查询语句，称为主查询或外查询

分类：
按子查询出现的位置：
             select后面
                       仅仅支持标量子查询
             from后面
                        支持表子查询
             where后面或having后面
                        标量子查询
                        列子查询
             exisis后面（相关子查询）
                         支持表子查询
按结果集的行列数不同：
             标量子查询（结果只有一行一列）
             列子查询（结果集只有一列多行）
             行子查询（结果集只有一行多列）
             表子查询（结果集一般为多行多列）

*/
#一、where 或having后面
#1.标量子查询（单行子查询）
#2.列子查询（多行子查询）

/*
特点:
   1.子查询放在小括号内
   2.子查询一般放在条件的右侧
   3.标量子查询，一般搭配着单行操作符使用
   > < >= <= <> =
     列子查询：一般搭配多行操作符使用
   in、any/some、all
   4.子查询先执行
*/
#1.标量子查询
#案例1：谁的工资比 Abel高？
SELECT e1.last_name,e1.`salary`,e2.`last_name`,e2.`salary` FROM employees e1,employees e2
WHERE e1.`salary`<e2.`salary` AND e1.`last_name`='Abel';


SELECT 
  last_name,
  salary 
FROM
  employees 
WHERE salary > 
	  (SELECT 
	    salary 
	  FROM
	    employees 
	  WHERE last_name = 'Abel') ;

#案例2：返回job_id 与141号员工相同，salary比143号员工多的员工 姓名，job_id和工资
SELECT 
  last_name,
  job_id,
  salary 
FROM
  employees 
WHERE job_id = 
  (SELECT 
    job_id 
  FROM
    employees 
  WHERE employee_id = 141) 
  AND salary > 
  (SELECT 
    salary 
  FROM
    employees 
  WHERE employee_id = 143) ;

#案例3 返回公司工资最少的员工的last_name,job_id和salary
SELECT last_name,job_id,salary FROM employees
WHERE salary=(SELECT MIN(salary) FROM employees);

#案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资
#50号部门的最低工资
SELECT MIN(salary) FROM employees WHERE department_id=50;

SELECT 
  department_id,
  MIN(salary) 
FROM
  employees 
GROUP BY department_id 
HAVING MIN(salary) > 
  (SELECT 
    MIN(salary) 
  FROM
    employees 
  WHERE department_id = 50) ;

#非法使用标量子查询

#2.列子查询（多行子查询）
#案例1：返回location_id是1400或1700的部门中的所有员工姓名
#1.查询location_id是1400或1700的部门编号
 SELECT DISTINCT department_id FROM departments WHERE location_id IN (1400,1700); 
#2.查询部门编号为1中某一个的所有员工的姓名
SELECT 
  last_name 
FROM
  employees 
WHERE department_id IN 
  (SELECT DISTINCT 
    department_id 
  FROM
   departments 
  WHERE location_id IN (1400, 1700)) ;

#案例2 返回其他工种中比job_id为‘IT_PROG’工种所有工资低的员工的员工号、姓名、job_id以及salary
#1 返回job_id为‘IT_PROG’部门的工资
SELECT salary FROM employees WHERE job_id='IT_PROG';
#2 返回要求值 比1 任一的工资低
SELECT employee_id,last_name,job_id,salary 
FROM employees
 WHERE job_id<>'IT_PROG' 
 AND salary<ANY(SELECT salary FROM employees WHERE job_id='IT_PROG');

#3行子查询
#案例：查询员工编号最小并且工资最高的员工信息
SELECT * FROM employees
WHERE (employee_id,salary)=(
       SELECT MIN(employee_id),MAX(salary)
       FROM employees
);

##二、select后面
#案例：查询每个部门的员工个数
SELECT 
  d.*,
  (SELECT 
    COUNT(*) 
  FROM
    employees e 
  WHERE e.department_id = d.department_id) 个数 
FROM
  departments d ;
  
#####案例2：查询员工号=102的部门名
SELECT 
  d.`department_name`,
  (SELECT 
    e.employee_id 
  FROM
    employees e 
  WHERE e.employee_id = 102 
    AND e.department_id = d.department_id)  员工名
FROM
  departments d 
HAVING 员工名 IS NOT NULL;
  ###体会having 和where的区别

  
 #三、from 后面
/*
将子查询的结果充当一张表，要求必须起别名

*/ 
 
 
 
 #案例：查询每个部门的平均工资的工资等级
 #1.查询每个部门的平均工资
 SELECT AVG(salary),department_id
 FROM employees
 GROUP BY department_id
 
 #2.连接两表，查询工资等级
 SELECT ag.*,g.`grade_level`
 FROM (
	  SELECT AVG(salary) ag,department_id
	  FROM employees
	  GROUP BY department_id
 ) ag
 INNER JOIN `job_grades` g
 ON ag.ag BETWEEN g.`lowest_sal` AND g.`highest_sal`;
  
#四、exists后面（相关子查询）意思是 是否存在  判断是否有值
/*
语法：
     exists(完整的查询语句)
结果：
1或0
*/
SELECT EXISTS(SELECT employee_id FROM employees );
#案例1：查询有员工的部门名
SELECT 
  department_name 
FROM
  departments d 
WHERE EXISTS 
  (SELECT 
    * 
  FROM
    employees e 
  WHERE e.`department_id` = d.`department_id`) ;
#用列子查询
SELECT 
  department_name 
FROM
  departments d 
WHERE d.`department_id` IN 
  (SELECT 
    e.`department_id` 
  FROM
    employees e 
  WHERE e.`department_id` = d.`department_id`) ;
#案例2：查询没有女朋友的男神信息
SELECT 
  bo.* 
FROM
  boys bo 
WHERE NOT EXISTS 
  (SELECT 
    * 
  FROM
    beauty b 
  WHERE b.`boyfriend_id` = bo.`id`) ;

#in
SELECT bo.*
FROM boys bo
WHERE bo.`id` NOT IN (SELECT b.`boyfriend_id` FROM beauty b );


                #测 试
#1. 查询和 Zlotkey 相同部门的员工姓名和工资
SELECT e.`last_name`,e.`salary`
FROM employees e
WHERE e.`department_id`=(
		SELECT e1.`department_id` 
		FROM employees e1                           ####用=还是in 取决于后面是标量  还是一列
		WHERE e1.`last_name`='Zlotkey'
);
#2. 查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT e.`employee_id`,e.`last_name`,e.`salary`
FROM employees e
WHERE e.`salary`>(
	SELECT AVG(salary)
	FROM employees
);
#3. 查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资
#1.查询每个部门的平均工资
SELECT AVG(salary),department_id FROM employees GROUP BY department_id;

SELECT employee_id,last_name,salary FROM employees e
INNER JOIN (SELECT AVG(salary) s,department_id FROM employees GROUP BY department_id) ag
ON e.`department_id`=ag.department_id
WHERE e.`salary`>ag.s

#4. 查询和姓名中包含字母 u 的员工在相同部门的员工的员工号和姓名
#1.查询姓名中包含字母u的员工的部门号
SELECT DISTINCT e.`department_id`
FROM employees e
WHERE e.`last_name` LIKE '%u%';

SELECT e1.`last_name`,e1.`employee_id`
FROM employees e1
WHERE e1.`department_id` IN (SELECT DISTINCT e.`department_id`
FROM employees e
WHERE e.`last_name` LIKE '%u%');

#5. 查询在部门的 location_id 为 1700 的部门工作的员工的员工号
SELECT e.`employee_id`
FROM employees e
WHERE e.`department_id` IN (
	SELECT d.`department_id`
	FROM departments d
	WHERE d.`location_id`=1700
);
#6. 查询管理者是 King 的员工姓名和工资
SELECT e.`last_name`,e.`salary`
FROM employees e
WHERE e.`manager_id` IN (
	SELECT e1.`employee_id`
	FROM employees e1
	WHERE e1.`last_name`='K_ing'
) ;
 
#7. 查询工资最高的员工的姓名，要求 first_name 和 last_name 显示为一列，列名为 姓.名
SELECT CONCAT(e.`first_name`,'-',e.`last_name`) `姓.名`
FROM employees e
WHERE e.`salary`=(
	SELECT MAX(salary)
	FROM employees
);







