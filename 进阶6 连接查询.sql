#进阶6：连接查询
/*
含义：又称多表查询，当查询的字段来自于多个表时，就会用到连接查询
笛卡尔乘积：表1 m行 表2 n行 结果=m*n行

发生原因：没有有效的连接条件
避免方法：添加有效的连接条件

分类：  
         按年代分类：
         sq192标准：仅支持内连接
         sq199标准【推荐】：支持内连接、外连接（左外和右外）、交叉连接
         
         按功能分类：
                   内连接：
                           等值连接
                           非等值连接
                           自连接
                   外连接：
                           左外连接
                           右外连接
                           全连接
                   交叉连接

*/
 SELECT NAME,boyName FROM beauty,boys
 WHERE beauty.`boyfriend_id`=boys.`id`;
 
 
 #一、sql 92标准
 #1.等值连接
/*
1.多表等值连接的结果为多表的交集部分
2.n表连接，至少需要n-1个连接条件
3.多表的顺序没有要求
4.一般需要起别名
5.可以搭配所有子句使用。
*/ 
 #案例1：查询女神名和对应的男神名
  SELECT NAME,boyName FROM beauty,boys
 WHERE beauty.`boyfriend_id`=boys.`id`;
 
#案例2：查询员工名和对应的部门名
SELECT 
  last_name,
  `department_name` 
FROM
  employees e,
  departments d 
WHERE e.`department_id` = d.department_id ;


#2.为表起别名
/*
1.提高语句的简洁度
2.区分多个重名的字段

注意：如果为表起了别名，则查询的字段就不能使用原来的表明去限定

*/

#查询员工名、工种号、工种名
SELECT last_name,job_id,job_title FROM employees,jobs WHERE employees.`job_id`=jobs.`job_id`;  ###体会这个错误
SELECT last_name,employees.job_id,job_title FROM employees,jobs WHERE employees.`job_id`=jobs.`job_id`;


#3.两个表的顺序是可以调换的
SELECT last_name,employees.job_id,job_title FROM  jobs,employees WHERE employees.`job_id`=jobs.`job_id`;


#4.可以加筛选吗
#案例 查询有奖金的员工名和部门名
SELECT 
  last_name,
  department_name,commission_pct
FROM
  employees e,
  departments d 
WHERE `commission_pct` IS NOT NULL 
  AND e.`department_id` = d.`department_id` ;

#案例2：查询城市名中第二个字符为o的部门名和城市名
SELECT 
  department_name,
  city 
FROM
  departments d,
  locations l 
WHERE d.`location_id` = l.`location_id` 
  AND l.`city` LIKE '_o%' ;
  
#5.可以加分组吗
#案例1：查询每个城市的部门个数
SELECT 
  COUNT(*) 个数,
  city 
FROM
  departments d,
  locations l 
WHERE d.`location_id` = l.`location_id` 
GROUP BY l.`city` ;
#案例2：查询出有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name,d.manager_id,MIN(salary) 
FROM departments d,employees e 
WHERE e.`department_id`=d.`department_id` AND `commission_pct` IS NOT NULL  
GROUP BY department_name,d.`manager_id`; 
##select后面跟着两个查询，我们不能确定这两个字段是否一一对应，所以要在groupby 后面两个都加上。
#6.可以加排序
#案例：查询每个工种的工种名和员工的个数，并且按员工的个数降序
SELECT 
  job_title,
  COUNT(*) 个数 
FROM
  employees e,
  jobs j 
WHERE e.`job_id` = j.`job_id` 
GROUP BY job_title 
ORDER BY 个数 DESC;

#7.三表连接
#案例：查询员工名、部门名和所在的城市
SELECT 
  last_name,
  department_name,
  city 
FROM
  employees e,
  departments d,
  locations l 
WHERE e.`department_id` = d.`department_id`  
  AND d.`location_id` = l.`location_id` ;
  
  
#2.非等值连接
#案例1：查询员工的工资和工资级别
SELECT 
  salary,
  grade_level 
FROM
  employees e,
  job_grades g 
WHERE salary BETWEEN g.`lowest_sal` 
  AND g.`highest_sal` ;
/*
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  int,
 highest_sal int);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);
*/
#3.自连接
#案例：查询 员工名和上级的名称
SELECT 
  e1.last_name 员工名,
  e2.last_name 上级名 
FROM
  employees e1,
  employees e2 
WHERE e1.`manager_id` = e2.`employee_id` ;

                  测 试
#1. 显示所有员工的姓名，部门号和部门名称。
SELECT last_name,d.department_id,department_name FROM employees e,departments d WHERE e.department_id=d.department_id;

2. 查询 90 号部门员工的 job_id 和 90 号部门的 location_id
SELECT job_id,location_id FROM employees e,locations l WHERE e.department_id=l.department_id AND e.department_id=90;

3. 选择所有有奖金的员工的 last_name,department_name,location_id,city 
SELECT 
  last_name,
  department_name,
  d.location_id,
  city 
FROM
  employees AS e,
  departments d,
  locations l 
WHERE e.department_id=d.department_id AND d.location_id=l.location_id AND `commission_pct`IS NOT NULL; 
#4. 选择 city 在 Toronto 工作的员工的 last_name,job_id,department_id,department_name
SELECT last_name,job_id,d.department_id,department_name,city FROM employees e,departments d,locations l
WHERE e.`department_id`=d.`department_id` AND d.`location_id`=l.`location_id` AND city='Toronto';

#5. 查询每个工种、每个部门的部门名、工种名和最低工资 
SELECT 
  department_name,
  job_title,
  MIN(salary),
  e.`job_id`,
  e.`department_id` 
FROM
  employees e,
  departments d,
  jobs j 
WHERE e.`department_id` = d.`department_id` 
  AND e.`job_id` = j.`job_id` 
GROUP BY e.`job_id`,
  e.`department_id` ;

 #6. 查询每个国家下的部门个数大于 2 的国家编号 
SELECT  country_id,COUNT(*) 部门个数
FROM departments d,locations l
WHERE d.`location_id`=l.`location_id`
GROUP BY country_id
HAVING 部门个数>2;
 
 #7 、选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式 
#  employees      Emp#       manager Mgr#
#  kochhar 101    king       100 
  
SELECT  e1.`last_name` employees,e1.`employee_id` Emp,e2.`last_name` manager,e2.`employee_id` Mgr 
FROM employees e1,employees e2
WHERE e1.`manager_id`=e2.`employee_id` AND e1.`employee_id`=101;
  
  
  
  
  
  
  
  
  
  
  
  
  
  