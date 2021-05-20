#视图
/*
含义：虚拟表，和普通表一样使用
mysql5.1出现的新特性，是通过表动态生成的数据
           语法           是否占用物理空间           使用
视图    create view       只是保存了逻辑         增删改查，一般不能增删改

表      create table      保存了数据             增删改查
*/
#案例：查询姓张的学生名和专业名
SELECT stuname,majorname
FROM stuinfo s
INNER JOIN major m ON s.majorid=m.`majorid`
WHERE s.`stuname` LIKE '张%';

CREATE VIEW v1
AS
SELECT stuname,majorname
FROM stuinfo s
INNER JOIN major m ON s.majorid=m.`majorid`;

SELECT * FROM v1 WHERE stuname='张%';


#一、创建视图
/*
语法：
create view 视图名
as
查询语句；
*/
USE myemployees;
#1.查询邮箱中包含a字符的员工名、部门名和工种信息
CREATE VIEW v2
AS
SELECT e.`last_name`,d.`department_name`,j.`job_title`
FROM employees e
INNER JOIN departments d ON e.`department_id`=d.`department_id`
INNER JOIN jobs j ON e.`job_id`=j.`job_id`;

SELECT * FROM v2 WHERE `last_name` LIKE '%a%';

#2.查询各部门的工资级别
CREATE VIEW v3
AS 
SELECT AVG(salary),`department_id`
FROM employees
GROUP BY department_id;

SELECT `department_id`,`grade_level`
FROM v3
INNER JOIN `job_grades` j
ON v3.`avg(salary)` BETWEEN j.`lowest_sal` AND j.`highest_sal`;

#3.查询平均工资最低的部门信息

SELECT * FROM v3 ORDER BY v3.`avg(salary)` LIMIT 1;

#4.查询平均工资最低的部门名和工资
CREATE VIEW v5
AS
SELECT * FROM v3 ORDER BY v3.`avg(salary)` LIMIT 1;

SELECT *
FROM v5
INNER JOIN departments d
ON v5.`department_id`=d.`department_id`;

#二、视图的修改
#方式一：
/*
creat or replace view 视图名
as
查询语句;
*/
SELECT * FROM v3;

CREATE OR REPLACE VIEW v3
AS
SELECT AVG(salary),job_id
FROM employees
GROUP BY job_id;

#方式二：
/*
语法：
alter view 视图名
as
查询语句；
*/

#三、删除视图
/*
语法：drop view 视图名，视图名。。。。

*/

#四、查看视图
DESC v3;

#五、视图的更新（基本都不能更新）
CREATE OR REPLACE VIEW myv1
AS
SELECT last_name,`email`
FROM employees;


SELECT * FROM myv1;
SELECT * FROM employees; 
#1.插入
INSERT INTO myv1 VALUES('张飞','zf@qq.com') ##对原始表也更新

#2.修改
UPDATE myv1 SET last_name ='张无忌' WHERE last_name='张飞';##对原始表也更新

#3.删除
DELETE FROM myv1 WHERE last_name ='张无忌';##对原始表也更新

#具备以下特点的视图不允许更新
/*
1、包含以下关键字的sql语句：分组函数、disrinct、group by、having、union或者union all
2、常量视图
3、select中包含子查询
4、join
5、from 一个不能更新的视图
6、where子句的子查询引用了from子句中的表
*/




