#进阶8：分页查询   重点但简单
/*
应用场景：当要显示的数据，一页显示不全，需要分页提交sql请求
语法：
    select 查询列表
    from 表1
    【type join 表2
    on 连接条件
    where 筛选条件
    group by 分组
    having 分组后筛选
    order by 排序】
    limit offset,size

    offset 要显示条目的起始索引（从0开始）
    size 要显示的条目个数
    
    
特点：
    1.limit语句放在查询语句的最后
    2.公式
       要显示的页数 page,每页的条目数size
       select 查询列表
       from 表
       limit (page-1)*size,size;
*/
#案例1 查询前五条员工信息
SELECT * FROM employees
LIMIT 0,5;

#案例2：查询第11条到第25条
SELECT * FROM employees
LIMIT 10,15;

#案例3：有奖金的员工信息，并且工资较高的前10名显示出来
SELECT * FROM employees
WHERE `commission_pct` IS NOT NULL 
ORDER BY salary DESC
LIMIT 10;


              #测 试
#1. 查询工资最低的员工信息: last_name, salary
SELECT last_name,salary 
FROM employees 
WHERE salary=(
      SELECT MIN(salary) FROM employees		
);

#2. 查询平均工资最低的部门信息
#方式一：
#1)各部门的平均工资 
 SELECT AVG(salary) a,e.`department_id` 
 FROM employees e
 GROUP BY e.`department_id`
#2）查询1）中的最低工资和部门id
SELECT MIN(ag.a)
FROM ( 
	SELECT AVG(salary) a,e.`department_id` 
	FROM employees e
	GROUP BY e.`department_id`
      ) ag
#3)根据2）中的最低工资  在1）中 查询部门id  
SELECT ag.b
FROM(
	 SELECT AVG(salary) a,e.`department_id`  b
	 FROM employees e
	 GROUP BY e.`department_id`

) ag
WHERE ag.a=(
	SELECT MIN(ag.a)
	FROM ( 
		SELECT AVG(salary) a,e.`department_id` 
		FROM employees e
		GROUP BY e.`department_id`
	      ) ag
)
#4)根据3找到部门信息
SELECT d.*
FROM departments d
WHERE d.department_id=(
	SELECT ag.b
	FROM(
		 SELECT AVG(salary) a,e.`department_id`  b
		 FROM employees e
		 GROUP BY e.`department_id`

	) ag
	WHERE ag.a=(
		SELECT MIN(ag.a)
		FROM ( 
			SELECT AVG(salary) a,e.`department_id` 
			FROM employees e
			GROUP BY e.`department_id`
		      ) ag
	)
)

###方式二 先排序，然后用limit 
##1)各部门的平均工资 
 SELECT AVG(salary) a,e.`department_id` 
 FROM employees e
 GROUP BY e.`department_id`
 #2）按工资进行升序
 SELECT AVG(salary) a,e.`department_id` 
 FROM employees e
 GROUP BY e.`department_id`
 ORDER BY a ASC
#(3)用limit 查出第一行 即为最小值
 SELECT AVG(salary) a,e.`department_id` 
 FROM employees e
 GROUP BY e.`department_id`
 ORDER BY a ASC
 LIMIT 0,1;  
#(4)用（3）的id 去找部门信息
SELECT d.*
FROM departments d
WHERE d.`department_id`=(
	SELECT ag.b
	FROM(
	         SELECT AVG(salary) a,e.`department_id` b 
		 FROM employees e
		 GROUP BY e.`department_id`
		 ORDER BY a ASC
		 LIMIT 0,1 		
	) ag
) 
 

#3. 查询平均工资最低的部门信息和该部门的平均工资
#(1).查询部门的平均工资
 SELECT AVG(salary) a,e.`department_id` 
 FROM employees e
 GROUP BY e.`department_id`
#(2).查询1中的最小值和id
 SELECT MIN(ag.a) 最小值
 FROM ( 
      SELECT AVG(salary) a
      FROM employees e
      GROUP BY e.`department_id`
      ) ag
#(3)根据2中的结果 在1）中查询部门id 
SELECT ag.b 
FROM(
	 SELECT AVG(salary) a,e.`department_id` b
	 FROM employees e
	 GROUP BY e.`department_id`
) ag
WHERE ag.a=(
	 SELECT MIN(ag.a) 最小值
	 FROM ( 
	      SELECT AVG(salary) a
	      FROM employees e
	      GROUP BY e.`department_id`
	      ) ag
)
#(4)根据（3）内连接（1）和部门表
SELECT *
FROM(
	SELECT ag.b 工资
	FROM(
		 SELECT AVG(salary) a,e.`department_id` b
		 FROM employees e
		 GROUP BY e.`department_id`
	) ag
	WHERE ag.a=(
		 SELECT MIN(ag.a) 最小值
		 FROM ( 
		      SELECT AVG(salary) a
		      FROM employees e
		      GROUP BY e.`department_id`
		      ) ag
	)
) g1
INNER JOIN departments d
ON g1.工资=d.department_id



#4. 查询平均工资最高的 job 信息
#(1)查询各个job的平均工资
SELECT AVG(salary) a,job_id
FROM employees
GROUP BY job_id
#(2)查询1中的最高工资和job_id
SELECT MAX(ag.a),ag.job_id b
FROM(
	SELECT AVG(salary) a,job_id
        FROM employees
        GROUP BY job_id  
) ag

#(3)查询 job_id 为2 的job信息
SELECT *
FROM jobs
WHERE job_id=(
	SELECT gg.b 
	FROM(
		SELECT MAX(ag.a),ag.job_id b
		FROM(
			SELECT AVG(salary) a,job_id
			FROM employees
			GROUP BY job_id  
		    ) ag
	    )gg
	 ) 


#5. 查询平均工资高于公司平均工资的部门有哪些?
#(1).查询公司的平均工资
SELECT AVG(salary) 
FROM employees
#(2)查询每个部门的平均工资
SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id
#(3)查询2中 平均工资大于1的部门
SELECT AVG(salary) a,department_id b
FROM employees
GROUP BY department_id
HAVING  a>(
	SELECT AVG(salary) 
        FROM employees
)

#6. 查询出公司中所有 manager 的详细信息.
SELECT *
FROM employees e
WHERE e.`employee_id` IN (
	SELECT DISTINCT e1.`manager_id`
	FROM employees e1
)

#7. 各个部门中 最高工资中最低的那个部门的 最低工资是多少
#(1).查询各个部门的最高工资
SELECT MAX(salary) a,e.`department_id`
FROM employees e
GROUP BY e.`department_id`

#(2).查询1.的最低工资
SELECT MIN(da.a)
FROM(
	SELECT MAX(salary) a,e.`department_id` b
        FROM employees e
	GROUP BY e.`department_id`
) da
#(3)根据（2）的工资 去找（1）中对应的id
SELECT  ag.b
FROM(
	SELECT MAX(salary) a,e.`department_id` b
	FROM employees e
	GROUP BY e.`department_id`
) ag
WHERE ag.a=(
	SELECT MIN(da.a)
	FROM(
		SELECT MAX(salary) a,e.`department_id` b
		FROM employees e
		GROUP BY e.`department_id`
	) da
)
#(4)
SELECT *
FROM(
	SELECT MAX(salary) a,e.`department_id` b
	FROM employees e
	GROUP BY e.`department_id`
) ag
WHERE ag.b=(
	SELECT  ag.b
	FROM(
		SELECT MAX(salary) a,e.`department_id` b
		FROM employees e
		GROUP BY e.`department_id`
	) ag
	WHERE ag.a=(
			SELECT MIN(da.a)
			FROM(
				SELECT MAX(salary) a,e.`department_id` b
				FROM employees e
				GROUP BY e.`department_id`
			) da
		)
)



#8. 查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email,salary
#(1).查询各部门的平均工资
SELECT AVG(salary) a,e.`department_id`
FROM employees e
GROUP BY e.`department_id`

#(2).查询1中的最高值
SELECT MAX(ag.a)
FROM(
	SELECT AVG(salary) a,e.`department_id` b
	FROM employees e
	GROUP BY e.`department_id`
) ag
#(3)根据2中的最高值从1找到部门id
SELECT ag.b
FROM(
	SELECT AVG(salary) a,e.`department_id` b
	FROM employees e
	GROUP BY e.`department_id`
) ag
WHERE ag.a=(
	SELECT MAX(ag.a)
	FROM(
		SELECT AVG(salary) a,e.`department_id` b
		FROM employees e
		GROUP BY e.`department_id`
	) ag
)

#(4)根据3中的部门id 找到主管id
SELECT d.manager_id
FROM departments d
WHERE d.`department_id` =(
		SELECT ag.b
		FROM(
			SELECT AVG(salary) a,e.`department_id` b
			FROM employees e
			GROUP BY e.`department_id`
		) ag
		WHERE ag.a=(
			SELECT MAX(ag.a)
			FROM(
				SELECT AVG(salary) a,e.`department_id` b
				FROM employees e
				GROUP BY e.`department_id`
			) ag
		)
)

#(5)查询要求值
SELECT last_name,department_id,email,salary
FROM employees e
WHERE e.`employee_id`=(
	SELECT d.manager_id
		FROM departments d
		WHERE d.`department_id` =(
				SELECT ag.b
				FROM(
					SELECT AVG(salary) a,e.`department_id` b
					FROM employees e
					GROUP BY e.`department_id`
				) ag
				WHERE ag.a=(
					SELECT MAX(ag.a)
					FROM(
						SELECT AVG(salary) a,e.`department_id` b
						FROM employees e
						GROUP BY e.`department_id`
					) ag
				)
		)
)

#一、查询每个专业的学生人数
SELECT COUNT(*),`majorid`
FROM student
GROUP BY `majorid`
#二、查询参加考试的学生中，每个学生的平均分、最高分
SELECT AVG(`score`),MAX(`score`),`studentno`
FROM result
GROUP BY `studentno`
#三、查询姓张的每个学生的最低分大于60的学号、姓名
SELECT s.`studentno`,s.`studentname`
FROM student s
INNER JOIN result r
ON s.`studentno`=r.`studentno`
WHERE s.`studentname` LIKE '张%'
GROUP BY s.`studentname`
HAVING MIN(r.`score`)>60
#四、查询专业生日在“1988-1-1”后的学生姓名、专业名称
SELECT s.`studentname`,m.`majorname`,`borndate`
FROM `student` s
INNER JOIN `major` m
ON s.`majorid`=m.`majorid`
WHERE DATEDIFF(`borndate`,'1988-1-1')>0
#五、查询每个专业的男生人数和女生人数分别是多少
SELECT COUNT(*),majorid,sex
FROM `student`
GROUP BY `majorid`,`sex`

##方式二
SELECT majorid,(SELECT COUNT(*) FROM student  WHERE sex='男' AND majorid=s.majorid) 男
,(SELECT COUNT(*) FROM student WHERE sex='女' AND majorid=s.majorid) 女
FROM student s
GROUP BY majorid

#六、查询专业和张翠山一样的学生的最低分
SELECT MIN(r.`score`)
FROM student s
INNER JOIN result r
ON s.`studentno`=r.`studentno`
WHERE s.`majorid`=(
	SELECT majorid
	FROM student
	WHERE `studentname`='张翠山'
)
#七、查询大于60分的学生的姓名、密码、专业名
SELECT s.`studentname`,s.`loginpwd`,m.`majorname`
FROM student s INNER JOIN result r ON s.`studentno`=r.`studentno`
INNER JOIN major m ON s.`majorid`=m.`majorid` 
WHERE r.`score`>60
#八、按邮箱位数分组，查询每组的学生个数
SELECT COUNT(*),s.email
FROM student s
GROUP BY LENGTH(s.`email`)
#九、查询学生名、专业名、分数
SELECT `studentname`,`majorname`,`score`
FROM student s INNER JOIN result r ON s.`studentno`=r.`studentno`
INNER JOIN major m ON s.`majorid`=m.`majorid` 

#十、查询哪个专业没有学生，分别用左连接和右连接实现
SELECT *
FROM major m
LEFT OUTER JOIN student s
ON m.`majorid`=s.`majorid`
WHERE s.`studentno` IS NULL

#十一、查询没有成绩的学生人数
SELECT COUNT(*)
FROM student s
LEFT OUTER JOIN result r
ON s.`studentno`=r.`studentno`
WHERE r.`id` IS NULL








