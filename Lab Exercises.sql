USE InternetSales



Alter Database InternetSales
Add FILEGROUP Mem_FG Contains
Memory_Optimized_Data;



Alter Database InternetSales
Add File (Name = 'MemData', FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\InternateSales.ndf')
To FileGroup Mem_FG;



CREATE TABLE ShoppingCart
(SessionID INT NOT NULL,
TimeAdded DATETIME NOT NULL,
CustomerKey INT NOT NULL,
ProductKey INT NOT NULL,
Quantity INT NOT NULL
PRIMARY KEY NONCLUSTERED (SessionID, ProductKey)) 
WITH  (MEMORY_OPTIMIZED = ON,  DURABILITY = SCHEMA_AND_DATA);



INSERT INTO ShoppingCart 
(SessionID, TimeAdded, CustomerKey, ProductKey, Quantity)
VALUES (1, GETDATE(), 2, 3, 1);
	
INSERT INTO ShoppingCart 
(SessionID, TimeAdded, CustomerKey, ProductKey, Quantity)
VALUES (1,GETDATE(), 2,4,1);


SELECT * FROM ShoppingCart;


CREATE PROCEDURE AddItemToCart
@SessionID INT, 
@TimeAdded DATETIME, 
@CustomerKey INT, 
@ProductKey INT, 
@Quantity INT
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN 
ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
INSERT INTO ShoppingCart 
(SessionID, TimeAdded, CustomerKey, ProductKey, Quantity)
VALUES (@SessionID, @TimeAdded, @CustomerKey, @ProductKey, @Quantity)
END



CREATE PROCEDURE DeleteItemFromCart
@SessionID INT, @ProductKey INT
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN 
ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
DELETE FROM ShoppingCart   
WHERE SessionID = @SessionID AND ProductKey = @ProductKey
END


CREATE PROCEDURE EmptyCart
@SessionID INT
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN 
ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
DELETE FROM ShoppingCart   WHERE SessionID = @SessionID
END



DECLARE @now DATETIME = GETDATE();
EXEC AddItemToCart @SessionID = 3, @TimeAdded = @now, @CustomerKey = 2, @ProductKey = 3,@Quantity = 1;
EXEC AddItemToCart  @SessionID = 3, @TimeAdded = @now, @CustomerKey = 2, @ProductKey = 4, @Quantity = 1;

SELECT * FROM ShoppingCart;

EXEC DeleteItemFromCart @SessionID = 3, @ProductKey = 4;

SELECT * FROM ShoppingCart;

EXEC EmptyCart @SessionID = 3;

SELECT * FROM ShoppingCart;

