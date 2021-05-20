#TCL
/*
Transaction Control Language 事务控制语言

事务：
 一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行。
 
案例：转账

张三丰 1000
郭襄   1000
 
事务的属性（ACID）:
  1、原子性(Atomicity)
     原子性是指事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生。
  2、一致性(Consistency)
     事务必须使数据库从一个一致性状态变换到另外一个一致性状态。
  3、隔离性(Isolation)
     事务的隔离性是指一个事务的执行不能被其他事务干扰，即一个事务内部的操作及使用的数据
     对并发的其他事务是隔离的，并发执行的各个事务之间不能相互干扰。
  4、持久性(Durability)
     持久性是指一个事务一旦被提交，他对数据库中的数据的改变就是永久性的，
     接下来的其他操作和数据库故障不应该对其有任何影响。

事务的创建
隐式事务：事务没有明显的开启和结束的标记
比如一条 insert\update\delete语句

显示事务：事务具有明显的开启和结束的标记

前提：必须先设置自动提交功能为禁用
set autocommit=0;

步骤1：开启事务
set autommit=0;
start transaction;可选的
步骤2：编写事务中的sql语句(select,insert,update,delete)
语句1；
语句2；
。。。
步骤3：结束事务
commit;提交事务
rollback;回滚事务

savepoint 节点名；设置回滚点


事务的隔离级别：         脏读       不可重复读         幻读
 read uncommitted:        Y            Y                Y
 read committed:          N            Y                Y
 repeatable read:         N            N                Y
 serializable:            N            N                N
mysql 中默认第三个隔离级别
oracle 中默认第二个隔离级别
查看隔离级别
select @@tx_isolation;
设置隔离级别
set session|global transaction isolation level 隔离级别；

*/
SHOW ENGINES;

SHOW VARIABLES LIKE 'autocommit';

#演示事务的使用步骤

DROP TABLE IF EXISTS accout;

CREATE TABLE account(
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(20),
	balance DOUBLE
);

INSERT INTO account(username,balance)
VALUES('张无忌',1000),('赵敏',1000);
SELECT* FROM account;
#开启事务
SET autocommit=0;
START TRANSACTION;
#编写一组事务的语句
UPDATE account SET balance=500 WHERE username='张无忌';
UPDATE account SET balance=1500 WHERE username='赵敏';
#结束事务
COMMIT;

#2.delete和truncate在事务使用时的区别
#演示delete 支持回滚
SET autocommit=0;
START TRANSACTION;
DELETE FROM account;
ROLLBACK;
#演示truncate 不支持回滚
SET autocommit=0;
START TRANSACTION;
TRUNCATE TABLE account;
ROLLBACK;

#3.演示savepoint 的使用
SET autocommit=0;
START TRANSACTION;
DELETE FROM account WHERE id=25;
SAVEPOINT a;#设置节点
DELETE FROM account WHERE id=28;
ROLLBACK TO a;





