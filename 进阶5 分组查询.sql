#进阶5：分组查询
/*
语法：
    select 分组函数，列（要求出现在group by 的后面）
    from 表
    【where 筛选条件】
    group by 分组的列表
    【order by 子句】
注意：
     查询的列表必须特殊，要求是分组函数和group by后出现的字段。

特点：
   1.分组查询中的筛选条件分为两类
                      数据源                      位置                           关键字
      分组前的筛选    原始表                      group by 子句的前面             where
      分组后的筛选    分组后的结果集              group by 子句的后面             having
        
      分组函数做条件肯定是放在having子句中。
      能用分组前筛选的就用分组前的。
   2. group by 子句支持单个字段分组，多个字段分组（多个字段之间用逗号隔开，没有顺序要求），表达式或函数（用得较少）
   3.也可以添加排序（排序放在整个分组查询的最后）
*/
#案例1 查询每个工种的最高工资
SELECT MAX(salary),job_id FROM employees GROUP BY job_id;
#案例2 查询每个位置上的部门个数
SELECT COUNT(*),location_id FROM departments GROUP BY location_id;

##添加分组前的筛选
#案例3 【添加条件】查询邮箱中包含a字符的，每个部门的平均工资。
SELECT 
  AVG(salary),
  email,
  department_id 
FROM
  employees 
WHERE email LIKE '%a%' 
GROUP BY department_id ;

#案例4 查询有奖金的每个领导手下员工的最高工资
SELECT 
  MAX(salary),
  manager_id 
FROM
  employees 
WHERE commission_pct IS NOT NULL 
GROUP BY manager_id ;

##添加分组后的筛选条件
#案例1  查询那个部门的员工个数>2
#1.查询每个部门的员工个数 2，根据1的结果查询那个部门的员工个数>2
SELECT COUNT(*),department_id FROM employees GROUP BY department_id HAVING COUNT(*)>2;

#案例2 查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
#1. 查询每个工种有奖金的员工的最高工资；
#2.查询1的结果中>12000的员工。
SELECT job_id,MAX(salary) FROM employees WHERE `commission_pct` IS NOT NULL  GROUP BY job_id HAVING MAX(salary)>12000;

#案例3 查询领导编号>102的每个领导手下的最低工资>5000的员工编号是哪个，以及其最低工资。
1.查询每个领导手下员工的最低工资
SELECT MIN(salary),manager_id FROM employees GROUP BY manager_id;
2.添加条件 领导编号>102
SELECT MIN(salary),manager_id FROM employees WHERE manager_id>102 GROUP BY manager_id;
3.添加条件 最低工资大于5000
SELECT manager_id,employee_id,MIN(salary) FROM employees WHERE manager_id>102 GROUP BY manager_id HAVING MIN(salary)>5000;


#按表达式或函数分组
#案例 按员工姓名的长度分组，查询每一组的员工个数，筛选员工个数>5的有哪些。
SELECT COUNT(*) 员工个数,LENGTH(last_name) 长度 FROM employees GROUP BY LENGTH(last_name) HAVING 员工个数>5;

#按多个字段进行分组
#案例：查询每个部门每个工种的员工的平均工资
SELECT AVG(salary),department_id,job_id FROM employees GROUP BY department_id,job_id;

#添加排序
#案例：查询每个部门每个工种的员工的平均工资,并且按平均工资的高低显示
案例：查询每个部门每个工种的员工的平均工资
SELECT AVG(salary),department_id,job_id FROM employees GROUP BY department_id,job_id ORDER BY AVG(salary) DESC;


测试 1. 查询各 job_id 的员工工资的最大值，最小值，平均值，总和，并按 job_id 升序 
SELECT 
  MAX(salary),
  MIN(salary),
  AVG(salary),
  SUM(salary),
  job_id 
FROM
  employees 
GROUP BY job_id 
ORDER BY job_id ;

2. 查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT MAX(salary)-MIN(salary) DIFFERENCE FROM employees;

3. 查询各个管理者手下员工的最低工资，其中最低工资不能低于 6000 ，没有管理者的员工不计算在内 
SELECT 
  MIN(salary),
  manager_id 
FROM
  employees 
WHERE manager_id IS NOT NULL 
GROUP BY manager_id 
HAVING MIN(salary) >= 6000 ;

4. 查询所有部门的编号，员工数量和工资平均值,并按平均工资降序
SELECT department_id,COUNT(*),AVG(salary) FROM employees GROUP BY department_id ORDER BY AVG(salary) DESC;

5. 选择具有各个 job_id 的员工人数
SELECT COUNT(*),job_id FROM employees GROUP BY job_id;

