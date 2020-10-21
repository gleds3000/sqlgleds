--Script que busca valores em qualquer campo das tabelas de um banco

DECLARE @value VARCHAR(64)   
DECLARE @sql VARCHAR(1024)   
DECLARE @table VARCHAR(64)   
DECLARE @column VARCHAR(64)   

--DROP TABLE #t  
SET @value = '%TEXTO%'
  
CREATE TABLE #t (   
    tablename VARCHAR(64),   
    columnname VARCHAR(64)   
)
DECLARE TABLES CURSOR  
FOR  
  
    SELECT o.name, c.name  
    FROM syscolumns c   
    INNER JOIN sysobjects o ON c.id = o.id   
    WHERE o.type = 'U' AND c.xtype IN (167, 175, 231, 239,36,99)  --busca para os tipos CHAR, NCHAR, VARCHAR, NVARCHAR, UNIQUEIDENTIFIER e NTEXT. Se quiser incluir mais tipos, buscar os ids na tabela systypes
    ORDER BY o.name, c.name  
  
OPEN TABLES 

FETCH NEXT FROM TABLES   
INTO @table, @column  
  
WHILE @@FETCH_STATUS = 0   
BEGIN  
    SET @sql = 'IF EXISTS(SELECT NULL FROM [' + @table + '] '  
    SET @sql = @sql + 'WHERE [' + @column + '] like ''' + @value + ''') '  
    SET @sql = @sql + 'INSERT INTO #t VALUES (''' + @table + ''', '''  
    SET @sql = @sql + @column + ''')'  
  

    EXEC(@sql)   
  
    FETCH NEXT FROM TABLES   
    INTO @table, @column  
END  

CLOSE TABLES   
DEALLOCATE TABLES   
  
SELECT * FROM #t
