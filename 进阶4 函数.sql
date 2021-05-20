`myemployees`#进阶4 常见函数
/*
概念：类似于java中的方法，将一组逻辑语句封装在方法体中，对外暴露方法名
好处：1，隐藏了实现细节 2，提高代码的重用性
调用：select 函数名（实参列表）【from 表】；
特点：
     1.叫什么（函数名）
     2.干什么（函数功能） 
分类：
1.单行函数
condat、length、ifnull
2.分组函数
功能：做统计用，又叫统计函数、聚合函数、组函数

常见函数：一、单行函数
   字符函数：length、concat、substr、instr、trim、upper、lower、lpad、rpad、replace
   数学函数：round、ceil、floor、truncate、mod
   日期函数：now、curdate、curtime、year、month、monthname、day、hour、minute、second、str_to_date、data_format
   其它函数：version、database、user、if、case

*/
#一、字符函数
#1.length
SELECT LENGTH('john');
SELECT LENGTH('张三丰');#一个汉字占三个字节

#2.concat 拼接字符串
SELECT CONCAT(last_name,'_',first_name) FROM employees;

#3.upper、lower
SELECT UPPER('john');
SELECT LOWER('joHn');
#示例：将姓变大写，名变小写，然后拼接
SELECT CONCAT(UPPER(last_name),'_',LOWER(first_name)) 姓名 FROM employees;

#4.substr、substring 截取字符串
#注意的是 字符串索引从1开始数
##只有一个索引值，表示从该位置后面所有的字符
SELECT SUBSTR('李莫愁爱上了陆展元',6) output;
##有两个值，表示从第一个索引值处截取第二个字符长度的字符
SELECT SUBSTR('李莫愁爱上了陆展元',1,3) output;

#案例：将姓名中首字符大写，其他字符小写然后用_拼接，显示出来。
SELECT 
  CONCAT(
    UPPER(SUBSTR(last_name, 1, 1)),
    '_',
    LOWER(SUBSTR(last_name, 2))
  ) 
FROM
  employees ;
  
#5.instr ##返回子串第一次出现的起始索引值，如果没有返回0
SELECT INSTR('杨不悔爱上了殷六侠','殷六侠') AS out_put; 

#6.trim 去掉前后空格 或指定字符
SELECT TRIM('    张翠山       ')
SELECT TRIM('a' FROM 'aaaaa  张aaa翠山aaaaaa') AS output;
SELECT TRIM('aa' FROM 'aaaaa  张aaa翠山aaaaaa') AS output;

#7.lpad 用指定的字符 左填充 指定长度
SELECT LPAD('殷素素',10,'*') output;
SELECT LPAD('殷素素',2,'*') output; ##这里需要注意，若字符不满足长度，不填充，而且会截取给定字符串。就是长度是一定的。

#8.rpad 用指定的字符 左填充 指定长度
SELECT RPAD('殷素素',10,'ab') output;

#9.replace 替换
SELECT REPLACE('周芷若周芷若周芷若周芷若张无忌爱上了周芷若','周芷若','赵敏') output;

#二、数学函数
#1、round 四舍五入
SELECT ROUND(1.65);
SELECT ROUND(-1.5);
SELECT ROUND(1.657,2);##保留两位小数

#2、ceil向上取整,返回>=该参数的最小整数
SELECT CEIL(1.002);
SELECT CEIL(-1.65);
# floor 向下取整，返回<=改参数的最大整数

#truncate 截断,小数点后截断
SELECT TRUNCATE(1.65344,1);
SELECT TRUNCATE(1.65344,4);

#mod 取余
/*
mod(a,b): a-a/b*b
*/
SELECT MOD(10,3);
SELECT MOD(-10,3);
SELECT MOD(-10,-3); ##只看被除数的正负。

##三、日期函数
#now 返回当前系统日期+时间
SELECT NOW();

#curdate 返回当前系统日期，不包含时间。
SELECT CURDATE();

#curtime 返回当前时间 不包含日期
SELECT CURTIME();

#可以获取指定的部分，年、月、日、小时、分钟、秒
SELECT YEAR(NOW());
SELECT YEAR('1998-12-21');

SELECT YEAR(hiredate) FROM employees;

SELECT MONTH(NOW());
SELECT MONTHNAME(NOW());

#str_to_date 将字符通过指定的格式转换成日期
SELECT STR_TO_DATE('1998-3-2','%Y-%c-%d') AS out_put;
/*
1  %Y   四位的年份
2  %y   二位的年份
3  %m   月份（01,02,...,12)
4  %c   月份（1,2,3,....12）
5  %d   日（01,02,...）
6  %H   小时（二十四小时制）
7  %h   小时（12小时制）
8  %i   分钟（00,01,...59）
9  %s   秒
*/
SELECT * FROM employees WHERE hiredate='1992-4-3';
SELECT * FROM employees WHERE hiredate=STR_TO_DATE('4-3 1992','%c-%d %Y');

##date_format 将日期转换成字符
SELECT DATE_FORMAT(NOW(),'%y年-%m月%d日') AS opt_put;
##查询有奖金的员工名和入职日期（XX月/xx日 xx年）
SELECT last_name,DATE_FORMAT(hiredate,'%m月/%d日 %Y年') AS 日期 FROM employees WHERE `commission_pct` IS NOT NULL;

#四、其他函数
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

#五、流程控制函数
#1.if 函数： if else 效果
SELECT IF(10>5,'大','小');

#2.case函数的使用一：swich case 的效果

/*
swich(常量或表达式){
    case 常量1：语句1；break;
    default:语句；break;
    }
mysql 中 
case 要判断的字段或表达式
when 常量1 then 要显示的值或语句1
when 常量2 then 要显示的值2或语句2；
...
else 要显示的值n或语句n;
end
*/

/*#案例：查询员工的工资，要求
部门号=30，显示的工资为1.1倍
部门号=40，显示的工资为1.2倍
部门号=50，显示的工资为1.3倍
其他部门，显示的工资为原工资
*/
SELECT salary 原始工资,`department_id`,
CASE department_id 
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary 
END AS 新工资
FROM employees;


#case 函数的使用二：类似于 多重if
/*
java 中：
if(条件一){
语句1：
}else if(条件2){
语句2；
}
...
else{
语句n;
)

mysql中：
case
when 条件1 then 要显示的值1或 语句
when 条件2 then 要显示的值2或语句2 
...
else 要显示的值n
end
*/

/*
#案例：查询员工的工资的情况
如果工资>20000,显示A级别
如果工资>15000,显示B级别
如果工资>10000,显示C级别
否则，显示D级别。
*/

SELECT salary,
CASE 
WHEN salary>20000 THEN 'A'
WHEN salary>15000 THEN 'B'
WHEN salary>10000 THEN 'C'
ELSE 'D'
END AS 级别
FROM employees;

/*   测试
1.显示系统时间
select now();
2.查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
SELECT `employee_id`,`last_name`,`salary`,`salary`*1.2 AS `new salary` FROM employees;
3.将员工的姓名按首字母排序，并写出姓名的长度
SELECT `last_name`,LENGTH(`last_name`) FROM employees ORDER BY `last_name`; 
4.
SELECT CONCAT(`last_name`,'earns',`salary`,'monthly but wants',`salary`*3) AS `Dream Salary` FROM employees;




*/
SELECT NOW();
SELECT `employee_id`,`last_name`,`salary`,`salary`*1.2 AS `new salary` FROM employees;


SELECT `last_name`,LENGTH(`last_name`) FROM employees ORDER BY `last_name`; 
SELECT `last_name`,LENGTH(`last_name`),SUBSTR(`last_name`,1,1) 首字符 FROM employees ORDER BY 首字符;

SELECT CONCAT(`last_name`,' earns ',`salary`,' monthly but wants ',`salary`*3) AS `Dream Salary` FROM employees WHERE salary=24000;

SELECT `last_name`,`job_id`,
CASE 
WHEN `job_id`='AD_PRES' THEN 'A'
WHEN `job_id`='ST_MAN' THEN 'B'
WHEN `job_id`='IT_PROG' THEN 'C'
WHEN `job_id`='SA_REP' THEN 'D'
WHEN `job_id`='ST_CLERK' THEN 'E'
END AS grade
FROM employees;










