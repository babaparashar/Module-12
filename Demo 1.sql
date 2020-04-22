Use MemPractice

Create Table Users
(UserId Integer Not Null PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),
UserName varchar(50) Not Null,
UserType bit NOT NULL,
UserTypeName varchar(20) NOT NULL,
EmailId varchar (50) NOT NULL,
Password varchar (16) NOT NULL,
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);



Create Table UsersDiskTable
(UserId Integer Not Null PRIMARY KEY NONCLUSTERED,
UserName varchar(50) Not Null,
UserType bit NOT NULL,
UserTypeName varchar(20) NOT NULL,
EmailId varchar (50) NOT NULL,
Password varchar (16) NOT NULL,
)


CREATE TABLE dbo.MemoryTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),
 date_value DATETIME NULL)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);


CREATE TABLE dbo.DiskTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED,
 date_value DATETIME NULL);


BEGIN TRAN
DECLARE @Diskid int = 1
WHILE @Diskid <= 500000
BEGIN
INSERT INTO dbo.DiskTable VALUES (@Diskid, GETDATE())
SET @Diskid += 1
END
COMMIT;


-- Time taken 52 Seconds


SELECT COUNT(*) FROM dbo.DiskTable;

BEGIN TRAN
DECLARE @Memid int = 1
WHILE @Memid <= 500000
BEGIN
INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
SET @Memid += 1
END
COMMIT;



-- Time taken 23 Seconds

SELECT COUNT(*) FROM dbo.MemoryTable;

DELETE FROM DiskTable;

-- Time taken 19 Seconds
DELETE FROM MemoryTable;
-- Time taken 0 Seconds


SELECT o.Name, m.*
FROM
sys.dm_db_xtp_table_memory_stats m
JOIN sys.sysobjects o
ON m.object_id = o.id



