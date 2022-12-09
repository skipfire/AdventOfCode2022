--Start off ensuring objects are correct
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day1')
BEGIN
	DROP TABLE Day1;
END;
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day1ElfTotal')
BEGIN
	DROP TABLE Day1ElfTotal;
END;
CREATE TABLE Day1 (Line VARCHAR(400));
CREATE TABLE Day1ElfTotal (ElfId INT, Calories INT);
--Import the data, 0x0a is a line feed character
DECLARE @SQL VARCHAR(MAX) = 'BULK INSERT Day1 FROM ''d:\GitHub\AdventOfCode2022\day-1\' + CAST(SERVERPROPERTY('MACHINENAME') AS VARCHAR(100)) + '.txt'' WITH (FIELDTERMINATOR='','', ROWTERMINATOR = ''0x0a'');'
EXECUTE (@SQL);
ALTER TABLE Day1 ADD ID INT IDENTITY(0,1);
ALTER TABLE Day1 ADD ElfID INT;

DECLARE @NullId INT = 0, @ElfId INT = 1, @NextId INT, @MaxId INT;
WHILE @NullId IS NOT NULL
BEGIN
	SELECT TOP 1 @NextId = ID FROM Day1 WHERE Line IS NULL AND ID > @NullId;
	UPDATE Day1 SET ElfId = @ElfId WHERE ID BETWEEN @NullId AND @NextId;
	IF @NextId = @NullId
	BEGIN
		UPDATE Day1 SET ElfId = @ElfId WHERE ElfId IS NULL;
		BREAK;
	END;
	SELECT @NullId = @NextId, @ElfId = @ElfId + 1;
END;
DELETE FROM Day1 WHERE Line IS NULL;
INSERT INTO Day1ElfTotal SELECT ElfId, SUM(CONVERT(INT, Line)) FROM Day1 GROUP BY ElfId;

SELECT TOP 1 Calories AS Puzzle1 FROM Day1ElfTotal ORDER BY Calories DESC;
SELECT SUM(Calories) As Puzzle2 FROM (SELECT TOP 3 Calories FROM Day1ElfTotal ORDER BY Calories DESC) as ivw;