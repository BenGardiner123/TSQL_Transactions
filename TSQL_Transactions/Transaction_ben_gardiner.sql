--Ben Gardiner 102151272

--SET IMPLICIT_TRANSACTIONS ON 
--UPDATE 
--    Person 
--SET 
--    Lastname = 'Sawyer', 
--    Firstname = 'Tom' 
--WHERE 
--    PersonID = 2 
--SELECT 
--    IIF(@@OPTIONS & 2 = 2, 
--    'Implicit Transaction Mode ON', 
--    'Implicit Transaction Mode OFF'
--    ) AS 'Transaction Mode' 
--SELECT 
--    @@TRANCOUNT AS OpenTransactions 
--COMMIT TRAN 
--SELECT 
--    @@TRANCOUNT AS OpenTransactions


--GO
--//-------------------------------------------------------------------------------
--BEGIN TRAN
 
--UPDATE Person 
--SET    Lastname = 'Lucky', 
--        Firstname = 'Luke' 
--WHERE  PersonID = 1
 
--SELECT 
--    @@TRANCOUNT AS OpenTransactions 
--COMMIT TRAN 
--SELECT 
--    @@TRANCOUNT AS OpenTransactions

--//-------------------------------------------------------------------------------

--BEGIN TRAN
--UPDATE Person 
--SET    Lastname = 'Donald', 
--        Firstname = 'Duck'  WHERE PersonID=2
 
 
--SELECT * FROM Person WHERE PersonID=2
 
--ROLLBACK TRAN 
 
--SELECT * FROM Person WHERE PersonID=2

--//-------------------------------------------------------------------------------
--BEGIN TRANSACTION 
--INSERT INTO Person 
--VALUES('Mouse', 'Micky','500 South Buena Vista Street, Burbank','California',43)
--SAVE TRANSACTION InsertStatement
--DELETE Person WHERE PersonID=3
--SELECT * FROM Person 
--ROLLBACK TRANSACTION InsertStatement
--COMMIT
--SELECT * FROM Person

--//-------------------------------------------------------------------------------

--BEGIN TRAN
--INSERT INTO Person 
--VALUES('Bunny', 'Bugs','742 Evergreen Terrace','Springfield',54)
    
--UPDATE Person SET Age='MiddleAge' WHERE PersonID=7
--SELECT * FROM Person
 
--COMMIT TRAN

--//-------------------------------------------------------------------------------

--BEGIN TRAN DeletePerson WITH MARK 'MarkedTransactionDescription' 

--DELETE Person WHERE PersonID BETWEEN 3 AND 4
    
--COMMIT TRAN DeletePerson