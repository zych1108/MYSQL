# MYSQL
The notes of learning MYSQL in Bilibili
##进阶1，基础查询
USE myemployees;

#1.查询表中单个字段
SELECT last_name FROM employees;
#2.查询表中多个字段
SELECT last_name,salary,email FROM employees ;
#3.查询表中所有字段
SELECT * FROM employees ;
#4.查询常量值
SELECT 100;
SELECT 'john';
SELECT '张宇','崔慧';
#5。查询表达式
SELECT 100%98;
#6.查询函数
SELECT VERSION();###?????
#7.起别名
/*
1.便于理解
2，有重名，便于区分
*/
SELECT 100%98 AS 结果；
SELECT 100%98 结果；
#8.去重
#案例：查询员工表中涉及到的所有的部门编号
SELECT `department_id` FROM employees;##有重复，理解题意不应重复。
SELECT DISTINCT `department_id` FROM employees;
#9.+号的作用；
/*
java 中的+：
1.运算符，两个操作数都为运算符；
2.连接符，只要有一个操作数为字符串。
myaql 的+号只是运算符:
   select 100+90;
   select '123'+90;有一方为字符型，试图将字符型数值转换成数值型，如果成功，则做加法；若不成功，则换成0；
                只要一方有null ,结果一定为null。
   select null+90;      
*/
#案例：查询员工的名和姓连接成一个字段，并显示为 姓名
##select last_name+first_name as 姓名 FROM employees；
SELECT CONCAT(last_name,first_name) AS 姓名 FROM employees;
/*
          测 试
1. 下面的语句是否可以执行成功
select last_name , job_id , salary as sal
from employees;
2. 下面的语句是否可以执行成功
select * from employees;

3. 找出下面语句中的错误
select employee_id，last_name，
salary * 12 “ANNUAL SALARY”
from employees;#####应该有英文符号。

4. 显示表 departments 的结构，并查询其中的全部数据
      DESC departments;  ###显示表的结构
      select * from departments;
      
5. 显示出表 employees 中的全部 job_id（不能重复）
      select distinct job_id from employees;

6. 显示出表 employees 的全部列，各个列之间用逗号连接，列头显示成 OUT_PUT
      select concat(`first_name`,',',`last_name`,',',`email`,',',`phone_number`,',',`job_id`,',',`salary`,',',`commission_pct`,',',`manager_id`,',',`department_id`,',',`hiredate`)
      as out_put from employeees;   ###此时结果显示为NULL，原因在于commisssion_pct 中有null值
 SELECT IFNULL(commission_pct,0) AS 奖金率 FROM employees;   判断是不是NULL 如果是就改为0
 SELECT CONCAT(`first_name`,',',`last_name`,',',`email`,',',`phone_number`,',',`job_id`,',',`salary`,',',IFNULL(`commission_pct`,0),',',`manager_id`,',',`department_id`,',',`hiredate`)
      AS out_put FROM employees;   
*/
SELECT IFNULL(commission_pct,0) AS 奖金率 FROM employees;   判断是不是NULL 如果是就改为0
SELECT CONCAT(`first_name`,',',`last_name`,',',`email`,',',`phone_number`,',',`job_id`,',',`salary`,',',IFNULL(`commission_pct`,0),',',`manager_id`,',',`department_id`,',',`hiredate`)
      AS out_put FROM employees;
