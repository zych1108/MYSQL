#进阶6-2 连接查询
#二、sql99语法
/*
语法：
  select 查询列表
  from 表1 别名【连接类型】
  join 表2 别名
  on 连接条件
  【where 筛选条件】
  【group by】
  【having】
  【order by】


分类：
  内连接：inner
  外连接：
        左外：left 【outer】
        右外：right 【outer】
        全外：full  【outer】
  交叉连接：cross
*/
#(一)内连接
/*
语法：
    select 查询列表
    from 表1 别名 inner
    join 表2 别名
    on 连接条件
    
分类：
等值
非等值
自连接

特点：
1.添加排序、分组、筛选
2.inner 可以省略
3.筛选条件放在where 后面，连接条件放在on 后面，提高分离性，便于阅读
4.inner join 和92中的效果一样。




*/
#1.等值连接
#案例1 查询员工名、部门名
SELECT last_name,department_name
FROM employees e 
INNER JOIN departments d
ON e.`department_id`=d.`department_id`;

#案例2 查询名字中包含e的员工名和工种名（添加筛选条件）
SELECT last_name,job_title 
FROM employees e 
INNER JOIN jobs j
ON e.`job_id`=j.`job_id`
WHERE e.`last_name` LIKE '%e%';

#案例3 查询部门个数>3的城市名和部门个数（添加分组和筛选）
SELECT city,COUNT(*) 部门个数
FROM departments d 
INNER JOIN locations l
ON d.`location_id`=l.`location_id`
GROUP BY city
HAVING 部门个数>3;

#案例4 查询部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）
SELECT department_name,COUNT(*) 员工个数
FROM departments d
INNER JOIN employees e
ON d.`department_id`=e.`department_id`
GROUP BY d.`department_id`
HAVING 员工个数>3
ORDER BY 员工个数 DESC;

#案例5 查询员工名、部门名、工种名，并按部门名降序（三表连接）
/*select last_name,department_name,job_title
from employees e
inner join departments d
inner join jobs j
on e.`department_id`=d.`department_id` and e.`job_id`=j.`job_id`    ###这个不标准
order by d.`department_name` desc;
*/
SELECT last_name,department_name,job_title
FROM employees e 
INNER JOIN departments d  ON e.`department_id`=d.`department_id`
INNER JOIN jobs j ON e.`job_id`=j.`job_id`
ORDER BY d.`department_name` DESC;

#2.非等值连接

#查询工资级别
SELECT salary,grade_level 级别
FROM employees e 
 JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`;

#查询每个工资级别的个数>2的个数，并且按工资级别降序。

SELECT salary,grade_level 级别,COUNT(*) 个数
FROM employees e 
 JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
GROUP BY g.`grade_level`
HAVING 个数>2
ORDER BY g.`grade_level` DESC;

#3 自连接
#查询员工的名字以及上级的名字
SELECT e1.`last_name` 员工名字,e2.`last_name` 上级名字
FROM employees e1
INNER JOIN employees e2
ON e1.`manager_id`=e2.`employee_id`;

##二、外连接
/*
应用场景：查询一个表中有另一个表中没有

特点：
1、外连接查询结果为主表中的所有记录
   如果从表中有和它匹配的，则显示匹配的值
   如果从表中没有和它匹配的，则显示null
   外连接查询结果=内连接结果+主表中有而从表中没有的记录。
2、左外 连接，left 左边的是主表
   右外             右
3、左外和右外交换两个表的顺序可以实现同样的效果 
4、全外连接=内连接+表1中有表2没有+表2有表1没有（不支持）

*/


#引入：查询男朋友不在男神表的女神名
##左外连接
SELECT b.name,bo.*
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`id`IS NULL;
##右外连接
SELECT b.name,bo.*
FROM boys bo
RIGHT OUTER JOIN beauty b
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`id`IS NULL;
##以上两个效果一样

/*内连接只显示交集
SELECT b.name,bo.*
FROM beauty b
inner JOIN boys bo
ON b.`boyfriend_id`=bo.`id`
*/#外连接交集 和不交集同时显示
  
#案例1：查询哪个部门没有员工
#左外
SELECT d.*,e.employee_id
FROM departments d
LEFT OUTER JOIN employees e
ON e.`department_id`=d.`department_id`
WHERE e.`employee_id` IS NULL;
#右外 
SELECT d.*,e.employee_id
FROM employees e
RIGHT OUTER JOIN departments d
ON e.`department_id`=d.`department_id`
WHERE e.`employee_id`IS NULL;

#全外
SELECT b.*,bo.*
FROM beauty b
FULL OUTER JOIN boys b
ON b.id=bo.id


#交叉连接
SELECT b.*,bo.*
FROM beauty b
CROSS JOIN boys bo;


#sql 92和sql 99

#一、查询编号>3的女神的男朋友的信息，如果有则列出详细，没有，用null填充
SELECT b.`id`,b.`name`,bo.*
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.`boyfriend_id`=bo.`id`
WHERE b.`id`>3;

#二、查询哪个城市没有部门
SELECT l.`city`,d.`department_id`
FROM locations l
LEFT OUTER JOIN departments d
ON l.`location_id`=d.`location_id`
WHERE d.`department_id`IS NULL;

#三、查询部门名为SAL或IT 的员工信息
SELECT d.`department_name`,e.*
FROM departments d
LEFT OUTER JOIN employees e
ON d.`department_id`=e.`department_id`
WHERE d.`department_name`='SAL' OR d.`department_name`='IT';
