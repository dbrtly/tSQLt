IF OBJECT_ID('tSQLt.ExpectNoException') IS NOT NULL DROP PROCEDURE tSQLt.ExpectNoException;
GO
---Build+
CREATE PROCEDURE tSQLt.ExpectNoException
  @Message NVARCHAR(MAX) = NULL
AS
BEGIN
IF OBJECT_ID('tempdb..#ExpectException') is not null
    BEGIN
        IF(EXISTS(SELECT 1 FROM #ExpectException WHERE ExpectException = 0))
            BEGIN
                DROP TABLE #ExpectException;
                RAISERROR('Each test can only contain one call to tSQLt.ExpectNoException.',16,10);
            END;
         IF(EXISTS(SELECT 1 FROM #ExpectException WHERE ExpectException = 1))
            BEGIN
                DROP TABLE #ExpectException;
            RAISERROR('tSQLt.ExpectNoException cannot follow tSQLt.ExpectException inside a single test.',16,10);
         END;
    END

SELECT ExpectException, FailMessage
INTO #ExpectException
FROM 
(
    VALUES(0, @Message)
)a
(ExpectException, FailMessage);
END;

