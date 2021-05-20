#进阶3 排序查询
/*
语法：
select 查询列表
from 表
【where 筛选条件】
order by [asc|desc]
特点：
1、asc 是升序（默认）
2、desc降序
3、支持单个字段、多个字段、表达式、函数、别名
4、order by 放在查询语句最后，limit子句除外。
*/
#案例1：查询员工信息，要求工资从高到低排序
USE myemployees;
SELECT * FROM employees ORDER BY salary DESC;
#案例2：查询部门编号>=90的员工信息，按入职时间的先后进行排序
SELECT * FROM employees WHERE department_id>=90 ORDER BY hiredate ASC;
#案例3：【按表达式排序】按年薪的高低显示员工的信息和年薪
SELECT 
  *,
  salary * 12 * (1+ IFNULL(`commission_pct`, 0)) AS 年薪 
FROM
  employees 
ORDER BY 年薪 DESC ###这里取的别名也可以直接用。 
  #案例5：【按函数排序】按姓名的长度显示员工的姓名和工资   length()求字段的长度
  SELECT 
    last_name,
    salary 
  FROM
    employees 
  ORDER BY LENGTH(last_name) DESC #案例6：【按多个字段排序】查询员工信息，要求先按工资排序，在员工编号排序
    SELECT 
      * 
    FROM
      employees 
    ORDER BY salary ASC,
      employee_id DESC #（工资一样的，会按员工编号排序）
      /*
                      测 试
1. 查询员工的姓名和部门号和年薪，按年薪降序 按姓名升序
SELECT last_name,department_id,salary*12*(1+IFNULL(`commission_pct`,0)) 年薪 FROM employees ORDER BY 年薪 DESC,last_name ASC;

2. 选择工资不在 8000 到 17000 的员工的姓名和工资，按工资降序
SELECT last_name,salary FROM employees WHERE salary NOT BETWEEN 8000 AND 17000 ORDER BY salary DESC;
3. 查询邮箱中包含 e 的员工信息，并先按邮箱的字节数降序，再按部门号升序
      SELECT 
        * 
      FROM
        employees 
      WHERE email LIKE '%e%' 
      ORDER BY LENGTH(email) DESC,
        department_id ASC ;

*/

