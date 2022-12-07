--Start off ensuring objects are correct
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day7')
BEGIN
	DROP TABLE Day7;
END;
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day7Sizes')
BEGIN
	DROP TABLE Day7Sizes;
END;

CREATE TABLE Day7 (Line VARCHAR(400));
CREATE TABLE Day7Sizes (Parent VARCHAR(400), [Path] VARCHAR(400), Depth INT, Size BIGINT);
--Import the data, 0x0a is a line feed character
DECLARE @SQL VARCHAR(MAX) = 'BULK INSERT Day7 FROM ''d:\GitHub\AdventOfCode2022\day-7\' + CAST(SERVERPROPERTY('MACHINENAME') AS VARCHAR(100)) + '.txt'' WITH (FIELDTERMINATOR='','', ROWTERMINATOR = ''0x0a'');'
EXECUTE (@SQL);
ALTER TABLE Day7 ADD ID INT IDENTITY(0,1);

DECLARE @MaxID INT;
SELECT @MaxID = MAX(ID) FROM Day7;

DECLARE @depth INT = 0, @ID INT = 0, @Line VARCHAR(400), @Parent VARCHAR(100);

WHILE @ID <= @MaxID
BEGIN
	SELECT @Line = Line FROM Day7 WHERE ID = @ID;
	IF @Line = '$ cd ..'
	BEGIN
		SELECT @Parent = Parent FROM Day7Sizes WHERE [Path] = @Parent;
		SELECT @Depth = @Depth - 1;
	END;
	ELSE
	BEGIN
		IF CHARINDEX('$ cd', @Line) = 1
		BEGIN
			DECLARE @NewDir VARCHAR(100) = ISNULL(@Parent, '') + TRIM(SUBSTRING(@Line, 5, LEN(@Line) - 4));
			IF(RIGHT(@NewDir, 1) <> '/') 
			BEGIN 
				SELECT @NewDir = @NewDir + '/';
			END;
			SELECT @Depth = @Depth + 1;
			INSERT INTO Day7Sizes (Parent, [Path], Depth, Size) VALUES (@Parent, @NewDir, @Depth, 0);
			SELECT @Parent = @NewDir;
		END;
		ELSE
		BEGIN
			IF @Line = '$ ls' OR CHARINDEX('dir ', @Line) = 1
			BEGIN
				PRINT 'Do nothing for ' + @Line;
			END;
			ELSE
			BEGIN
				DECLARE @FileSize BIGINT, @Name VARCHAR(100), @SpaceIndex INT = CHARINDEX(' ', @Line);				
				SELECT @FileSize = CONVERT(BIGINT, TRIM(SUBSTRING(@Line, 0, @SpaceIndex))), @Name = TRIM(SUBSTRING(@Line, @SpaceIndex, LEN(@Line) - @SpaceIndex));
				INSERT INTO Day7Sizes (Parent, [Path], Depth, Size) VALUES (@Parent, @Parent + @Name, @Depth + 1, @FileSize);
				
			END;
		END;
	END;

	SELECT @ID = @ID + 1;
END;

SELECT @Depth = MAX(Depth) FROM Day7Sizes;
WHILE @Depth > 0
BEGIN
	--This does end up creating duplciate folder records, one with a size and one without
	INSERT INTO Day7Sizes
	SELECT d1.Parent, d1.Path, d1.Depth, SUM(d2.Size) As Size
	FROM Day7Sizes d1
	INNER JOIN Day7Sizes d2 ON d1.[Path] = d2.Parent
	WHERE d1.Depth = @Depth AND d1.Size = 0
	GROUP BY d1.Parent, d1.Path, d1.Depth, d1.Size;
	SELECT @Depth = @Depth - 1;
	
END;
SELECT SUM(Size) As Puzzle1 FROM Day7Sizes WHERE Size <= 100000 AND [Path] LIKE '%/';

DECLARE @TotalSpace BIGINT = 70000000, @UsedSpace BIGINT, @FreeSpace BIGINT, @RequiredSpace BIGINT;
SELECT @UsedSpace = Size FROM Day7Sizes WHERE [Path] = '/' AND Size > 0;
SELECT @FreeSpace = @TotalSpace - @UsedSpace;
SELECT @RequiredSpace = 30000000 - @FreeSpace;
SELECT MIN(Size) As Puzzle2
FROM Day7Sizes
WHERE [Path] LIKE '%/' AND Size >= @RequiredSpace;
