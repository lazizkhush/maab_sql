
--Task 1

-- Table for storing all metadata
DECLARE @temp table(
    DatabaseName nvarchar(255),
    SchemaName nvarchar(255),
    ColumnName nvarchar(255),
    DataType nvarchar(255)
);

-- Table for storing all database Names
DECLARE @Databases TABLE (
    database_id INT IDENTITY(1,1),
    name NVARCHAR(255)
);

INSERT INTO @Databases (name)
SELECT [name]
FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
ORDER BY database_id;


DECLARE @i INT = 1;
DECLARE @NumberOfDatabases INT;
DECLARE @DatabaseName NVARCHAR(255);

-- Get total databases count
SELECT @NumberOfDatabases = COUNT(*) FROM @Databases;

-- Loop through the databases
WHILE @i <= @NumberOfDatabases
BEGIN
    -- Get database name by ID
    SELECT @DatabaseName = name FROM @Databases WHERE database_id = @i;

    -- Prepare query to get metadata of @DatabaseName
    DECLARE @sql_query NVARCHAR(MAX) = '
    SELECT
        TABLE_CATALOG AS [DatabaseName],
        TABLE_SCHEMA AS [Schema],
        COLUMN_NAME AS [ColumnName],
        CONCAT(DATA_TYPE,
               ''('' + 
                IIF(CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) = ''-1'', ''max'', CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR)) +
               '')'') AS DataType
    FROM ' + QUOTENAME(@DatabaseName) + '.INFORMATION_SCHEMA.COLUMNS;';

    -- Get metadata of @DatabaseName and save it to @temp table
    INSERT INTO @temp
    EXEC sp_executesql @sql_query;

    -- Increment counter
    SET @i = @i + 1;
END

SELECT * FROM @temp

go

-- TASK 2

CREATE PROCEDURE usp_GetProceduresAndFunctionsMetadata
    @DatabaseName NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Temp table for results
    DECLARE @Results TABLE (
        DatabaseName NVARCHAR(255),
        SchemaName NVARCHAR(255),
        RoutineName NVARCHAR(255),
        RoutineType NVARCHAR(255),
        ParameterName NVARCHAR(255),
        DataType NVARCHAR(255),
        MaxLength VARCHAR(50)
    );

    -- Table to hold all user database names
    DECLARE @Databases TABLE (
        id INT IDENTITY(1,1),
        name NVARCHAR(255)
    );

    IF @DatabaseName IS NULL
    BEGIN
        INSERT INTO @Databases (name)
        SELECT name
        FROM sys.databases
        WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
        ORDER BY name;
    END
    ELSE
    BEGIN
        INSERT INTO @Databases (name)
        SELECT @DatabaseName;
    END

    DECLARE @i INT = 1;
    DECLARE @count INT;
    SELECT @count = COUNT(*) FROM @Databases;

    WHILE @i <= @count
    BEGIN
        DECLARE @DBName NVARCHAR(255);
        SELECT @DBName = name FROM @Databases WHERE id = @i;

        DECLARE @SQL NVARCHAR(MAX) = '
        SELECT
            ''' + @DBName + ''' AS DatabaseName,
            ROUTINE_SCHEMA AS SchemaName,
            ROUTINE_NAME AS RoutineName,
            ROUTINE_TYPE AS RoutineType,
            PARAMETER_NAME AS ParameterName,
            DATA_TYPE AS DataType,
            CASE 
                WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN ''max''
                WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR)
                ELSE NULL
            END AS MaxLength
        FROM [' + @DBName + '].INFORMATION_SCHEMA.PARAMETERS p
        RIGHT JOIN [' + @DBName + '].INFORMATION_SCHEMA.ROUTINES r
            ON p.SPECIFIC_NAME = r.ROUTINE_NAME AND p.SPECIFIC_SCHEMA = r.ROUTINE_SCHEMA;';

        INSERT INTO @Results
        EXEC sp_executesql @SQL;

        SET @i = @i + 1;
    END

    SELECT * FROM @Results;
END

EXEC usp_GetProceduresAndFunctionsMetadata
 