--Ben Gardiner 102151272
--session 2 -dirty read
---read the uncommited data
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
--SELECT FirstName FROM EmployeeInfo
--WHERE EmpID = 1;


--session 2 -- waits fo rthe session 1 to finish before returning anything
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
--SELECT FirstName FROM EmployeeInfo
--WHERE EmpID = 1;

-------------------------------------------------------------
--non repeatable read
-------------------------------------------------------------
session 2

UPDATE EmployeeInfo
SET FirstName = 'Frank'
WHERE EmpID = 1;

-------------------------------------------------------------
--Serializable and Snapshot isolation levels difference
-------------------------------------------------------------


--session 2
UPDATE EmployeeInfo
SET FirstName = 'Harold'
WHERE EmpID = 1;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;

IF OBJECT_ID('EmployeeInfo') IS NOT NULL DROP TABLE EmployeeInfo;



CREATE TABLE EmployeeInfo

(

    EmpID int PRIMARY KEY IDENTITY(1,1),

    FirstName varchar(255),

    LastName varchar(255),

)

INSERT INTO EmployeeInfo

Values

    ('Bob', 'Builder'),

    ('Tim', 'Trader'),

    ('Yuri', 'Trainer'),

    ('Tom ', 'Tanker');

--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
--SELECT * FROM EmployeeInfo 
--WHERE EmpID = 1;

-----------------------------
--example of the dirty read
-----------------------------

---- session 1 -dirty read
--BEGIN TRANSACTION; 
 
--UPDATE EmployeeInfo
--SET FirstName = 'Frank'
--WHERE EmpID = 1;
 
--WAITFOR DELAY '00:00:10'  
 
--ROLLBACK TRANSACTION;

-----------------------------
--not repeatable read
-----------------------------
--session 1
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
--BEGIN TRANSACTION;
 
--SELECT FirstName FROM EmployeeInfo
--WHERE EmpID = 1;
 
--WAITFOR DELAY '00:00:10'  
 
--SELECT FirstName FROM EmployeeInfo
--WHERE EmpID = 1;
 
--ROLLBACK TRANSACTION;


----------------------------------------------------------
--changing the isolation level to repeatable read
-----------------------------------------------------------
--session 1SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
 
--BEGIN TRANSACTION;
 
--SELECT FirstName FROM EmployeeInfo
--WHERE EmpID = 1;
 
--WAITFOR DELAY '00:00:10'  
 
--SELECT FirstName FROM EmployeeInfo
--WHERE EmpID = 1;
 
--ROLLBACK TRANSACTION;

----------------------------------------------------------
Read Committed Snapshot
----------------------------------------------------------


----------------------------------------------------------
--How do I set the default transaction isolation level for write operations?”
----------------------------------------------------------
UPDATE EmployeeInfo WITH(TABLOCKX)
SET FirstName = 'Ken'
WHERE EmpID = 1;

----------------------------------------------------------
--“The Serializable and Snapshot isolation levels appear to achieve the
--same results. What are the differences between them?”
----------------------------------------------------------
--session 1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
 
BEGIN TRANSACTION;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;
 
WAITFOR DELAY '00:00:05'  
 
UPDATE EmployeeInfo
SET FirstName = 'Roger'
WHERE EmpID = 1;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;
 
COMMIT TRANSACTION;

----------------------------------------------------------
--“The Serializable and Snapshot isolation levels appear to achieve the
--same results. What are the differences between them?”
----------------------------------------------------------
--session 1
ALTER DATABASE Concurrency 
SET ALLOW_SNAPSHOT_ISOLATION ON;
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
 
BEGIN TRANSACTION;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;
 
WAITFOR DELAY '00:00:05'  
 
UPDATE EmployeeInfo
SET FirstName = 'Roger'
WHERE EmpID = 1;
 
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;
 
COMMIT TRANSACTION;

----------------------------------------------------------
--“switching to adventure works db"
----------------------------------------------------------

ALTER DATABASE AdventureWorks2016 
SET READ_COMMITTED_SNAPSHOT ON;
 
ALTER DATABASE AdventureWorks2016 
SET ALLOW_SNAPSHOT_ISOLATION ON;
 
ALTER DATABASE AdventureWorks2016 
SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT ON;



SELECT EmpID, FirstName, LastName 
FROM EmployeeInfo WITH(TABLOCK)
WHERE EmpID > 99
ORDER BY LastName;

SELECT *
FROM EmployeeInfo
WHERE EmpID > 99
ORDER BY LastName;

----------------------------------------------------------
--“How do I verify which snapshot-related database options are enabled on my database?”
----------------------------------------------------------

SELECT snapshot_isolation_state_desc 
FROM sys.databases 
WHERE name = 'AdventureWorks2014'

----------------------------------------------------------
--“How do I verify the transaction isolation levels that an application is using when connecting to the database?”
----------------------------------------------------------

--say when you runs this, inside the same sessino below you can add the 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT FirstName FROM EmployeeInfo
WHERE EmpID = 1;

--add this and you get 
SELECT transaction_isolation_level
FROM sys.dm_exec_sessions
WHERE session_id = @@SPID;
--In this case, the SELECT statement returns a value of 1. SQL Server uses the following values to represent the isolation levels available through the sys.dm_exec_sessions view:

--0 = Unspecified
--1 = Read Uncommitted
--2 = Read Committed
--3 = Repeatable
--4 = Serializable
--5 = Snapshot

---setting the below effecteseverything in that session
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
SELECT FirstName, LastName 
FROM EmployeeInfo
WHERE EmpID = 1;

--but if you want some finer grain control you can set only a table to a lockless state like this
SELECT FirstName, LastName 
FROM EmployeeInfo WITH(NOLOCK)
WHERE EmpID = 1;
