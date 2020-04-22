Use MemPractice

CREATE PROCEDURE dbo.InsertData
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
DECLARE @Memid int = 1
WHILE @Memid <= 500000
BEGIN
INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
SET @Memid += 1
END
END;

EXEC dbo.InsertData;

-- Time Taken 01 seccond


SELECT COUNT(*) FROM dbo.MemoryTable;



