#进阶四（2）分组函数
/*
功能：用作统计使用，有称为聚合函数或统计函数或组函数

分类：
sum、avg、max、min、count

特点：
  1.sum、avg 用于处理数值型
    max、min、count可以处理任何类型
  2.以上分组函数都忽略null值
  3.可以和distinct 搭配
  4.一般使用count(*)用作统计行数。
  5.和分组函数一同查询的字段要求是group by 后的字段
  
*/
#1.简单的使用
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT COUNT(salary) FROM employees;
SELECT SUM(salary),ROUND(AVG(salary),2),MAX(salary) FROM employees;

#2.参数支持哪些类型
SELECT SUM(last_name),AVG(last_name),SUM(hiredate) FROM employees;  ##不报错，但没有意义

SELECT MAX(last_name),MIN(hiredate)FROM employees;

SELECT COUNT(`commission_pct`) FROM employees;

#3.是否忽略null
SELECT  SUM(`commission_pct`),AVG(`commission_pct`) FROM employees;

SELECT  MAX(`commission_pct`),MIN(`commission_pct`) FROM employees;

SELECT  COUNT(`commission_pct`) FROM employees;

#4.去重
SELECT SUM(DISTINCT salary),SUM(salary) FROM employees;

SELECT COUNT(DISTINCT salary),COUNT(salary) FROM employees;

#5.count 函数的详细介绍
SELECT COUNT(*) FROM employees;  #统计表中的所有行  只要有一个字段不为空 就会统计加一行。
SELECT COUNT(2) FROM employees; ##相当于加一列 值为2；

效率：
MYISAM 存储引擎下，COUNT(*) 的效率高
INNODB 存储引擎下，COUNT(*)和COUNT(1)的效率差不多，比COUNT(字段)更高一些。

#6.和分组函数一同查询的字段有限制
SELECT AVG(salary),employee_id FROM employees;##这个不对

#案例1 查询公司员工工资的最大值，最小值，平均值，总和
 SELECT MAX(salary),MIN(salary),AVG(salary),SUM(salary) FROM employees;
#案例2 查询员工表中的最大入职时间和最小入职时间的相差天数
SELECT MAX(hiredate)-MIN(hiredate) 天数 FROM employees;
SELECT DATEDIFF(MAX(hiredate),MIN(hiredate)) FROM employees;
##datediff(日期1，日期2)
#案例3 查询部门编号为90的员工个数
SELECT COUNT(*) FROM employees WHERE department_id=90;





