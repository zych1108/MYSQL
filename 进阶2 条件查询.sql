##进阶2 条件查询
/*
语法：
   select 查询列表 from 表名 where 筛选条件；
分类：
   一、按条件表达式筛选
   条件运算符：> < = <> >= <=
   二、按逻辑表达式筛选
   逻辑运算符：&& || ！
               and or not
   三、模糊查询
           like
           between and
           in
           is null
 
*/
#一、按条件表达式筛选
##案例1：查询工资>12000的员工信息
SELECT  
   * 
FROM
  employees 
WHERE `salary` > 12000 ;
##案例2：查询部门编号不等于90号的员工名和部门编号
SELECT 
  `last_name`,
  `department_id` 
FROM
  employees 
WHERE `department_id` <> 90 ;
#二、按逻辑表达式筛选
##案例一：查询工资在10000到20000之间的员工名、工资以及奖金
SELECT 
  `last_name`,
  `salary`,
  `commission_pct` 
FROM
  employees 
WHERE `salary` >= 10000 
  AND `salary` <= 20000 ;
##案例二： 查询部门编号不是在90到110之间，或者工资高于15000的员工信息。
SELECT * FROM employees WHERE department_id<90 OR department_id>110 OR salary>15000;
SELECT * FROM employees WHERE NOT(department_id>=90 AND department_id<=110)OR salary>15000;

#三、模糊查询
/*
like
特点：
1、一般和通配符搭配使用
 通配符： %任意多个字符，包含0个字符
          _任意单个个字符
between and 
in
is null/is not null
*/
##案例一：查询员工名中包含字符a 的员工信息
SELECT * FROM employees WHERE last_name  LIKE '%a%'; 
##案例二：查询员工名中第三个字符为e ,第五个字符为a的员工名和工资
SELECT 
  last_name,
  salary 
FROM
  employees 
WHERE last_name LIKE '__n_l%' ;
##案例三：查询员工名中第二个字符为_的员工名
SELECT 
  last_name 
FROM
  employees 
WHERE last_name LIKE '_\_%' ;

SELECT last_name FROM employees WHERE last_name LIKE '_$_%' ESCAPE '$';###escape 指定转义符
#2.between and
/*
1.可以提高语句的简洁度
2.包含临界值
3.临界值不能换位置
SELECT * FROM employees WHERE `employee_id` BETWEEN 120 AND 100;
*/

#案例1：查询员工编号在100到120之间的员工信息
SELECT * FROM employees WHERE `employee_id` BETWEEN 100 AND 120;

#3.in
/*
含义： 判断某字段的值是否属于in 列表中的某一项；
特点：
    1.使用in可以提高简洁度
    2.不支持通配符
*/
##案例 查询员工的工种编号是IT_PROG、AD_VP、AD_PRES中的一个员工名和工种编号
SELECT last_name,job_id FROM employees WHERE job_id IN ('IT_PROG','AD_VP','AD_PRES');

#4.is null
/*
=或<>不能用于判断null值
is 只能判断null 不能判断指定值。
*/
#案例1 查询没有奖金的员工名和奖金率
SELECT last_name,commission_pct FROM employees WHERE  ISNULL(commission_pct);
SELECT last_name,commission_pct FROM employees WHERE  commission_pct IS NULL;

##安全等于<=>可以判断null值 也可以判断给定值
SELECT last_name,commission_pct FROM employees WHERE  commission_pct <=> NULL;
SELECT last_name,salary FROM employees WHERE salary <=> 12000;

###is null pk  <=>
/*
is null 只能判断null值
<=>既可以判断null值也可以判断常数值，但可读性差。

*/

#案例2 查询员工号为176 的员工的姓名和部门号和年薪
SELECT `last_name`,`department_id`,salary*12*(1+IFNULL(`commission_pct`,0)) AS 年薪 FROM employees WHERE `employee_id`=176;

/*
             测 试
1. 查询工资大于 12000 的员工姓名和工资
    select last_name,salary from employees where salary>12000;
2. 查询员工号为 176 的员工的姓名和部门号和年薪
    select last_name,department_id,salary*12*(1+IFNULL(`commission_pct`,0)) from employees where `employee_id`=176;
3. 选择工资不在 5000 到 12000 的员工的姓名和工资
    SELECT `last_name`,`salary` FROM employees WHERE salary NOT BETWEEN 5000 AND 12000;
4. 选择在 20 或 50 号部门工作的员工姓名和部门号
    SELECT `last_name`,`department_id` FROM employees WHERE `department_id` IN (20,50);
5. 选择公司中没有管理者的员工姓名及 job_id
    SELECT `last_name`,`job_id` FROM employees WHERE `manager_id` IS NULL;
6. 选择公司中有奖金的员工姓名，工资和奖金级别
    SELECT `last_name`,`salary`,`commission_pct` FROM employees WHERE `commission_pct` IS NOT NULL;
7. 选择员工姓名的第三个字母是 a 的员工姓名
    SELECT `last_name` FROM employees WHERE `last_name` LIKE '__a';
8. 选择姓名中有字母 a 和 e 的员工姓名
    SELECT `last_name` FROM employees WHERE `last_name` LIKE '%a%e%';
9. 显示出表 employees 表中 first_name 以 'e'结尾的员工信息
    SELECT * FROM employees WHERE `first_name` LIKE '%e';
10. 显示出表 employees 部门编号在 80-100 之间 的姓名、职位
    SELECT `last_name`,`job_id` FROM employees WHERE `department_id`BETWEEN 80 AND 100;
11. 显示出表 employees 的 manager_id 是 100,101,110 的员工姓名、职位
    SELECT `last_name`,`job_id` FROM employees WHERE `manager_id` IN (100,101,110);
*/
经典面试题
试问： SELECT * FROM employees;和
SELECT * FROM employees WHERE `commission_pct`LIKE '%%' AND `last_name` LIKE '%%';
SELECT * FROM employees WHERE `commission_pct`LIKE '%%' OR `last_name` LIKE '%%';
结果是否一样？说明原因。
答：不一样！判断的字段有NULL值；若没有NULL值则是一样的。
SELECT * FROM employees WHERE `commission_pct`LIKE '%%' OR `last_name` LIKE '%%';  用OR是一样的。
DESC departments;
