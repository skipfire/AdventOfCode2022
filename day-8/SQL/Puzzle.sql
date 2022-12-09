--Start off ensuring objects are correct
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day8')
BEGIN
	DROP TABLE Day8;
END;
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day8Tree')
BEGIN
	DROP TABLE Day8Tree;
END;
CREATE TABLE Day8 (Line VARCHAR(400));
CREATE TABLE Day8Tree (x INT, y INT, h INT, Visible BIT, ScenicScore INT);
--Import the data, 0x0a is a line feed character
DECLARE @SQL VARCHAR(MAX) = 'BULK INSERT Day8 FROM ''d:\GitHub\AdventOfCode2022\day-8\' + CAST(SERVERPROPERTY('MACHINENAME') AS VARCHAR(100)) + '.txt'' WITH (FIELDTERMINATOR='','', ROWTERMINATOR = ''0x0a'');'
EXECUTE (@SQL);
ALTER TABLE Day8 ADD RowNumber INT IDENTITY(0,1);
DECLARE @MaxRow INT, @Row INT = 0, @Width INT, @Column INT, @Line VARCHAR(400), @Height INT;
SELECT @MaxRow = MAX(RowNumber), @Width = MAX(LEN(Line)) FROM Day8;
WHILE @Row <= @MaxRow
BEGIN
	SELECT @Line = Line FROM Day8 WHERE RowNumber = @Row;
	SELECT @Column = 1;
	WHILE @Column <= @Width
	BEGIN
		SELECT @Height = CONVERT(INT, SUBSTRING(@Line, @Column, 1));
		INSERT INTO Day8Tree (x, y, h, Visible, ScenicScore) VALUES (@Column-1, @Row, @Height, 0, 0);
		SELECT @Column = @Column + 1;
	END;
	SELECT @Row = @Row + 1;
END;

DECLARE @BL INT, @BR INT, @BU INT, @BD INT;
DECLARE @RL INT, @RR INT, @RU INT, @RD INT;
DECLARE @Visible BIT;
SELECT @Row = 0;
WHILE @Row <= @MaxRow
BEGIN
	SELECT @Column = 0;
	WHILE @Column <= @Width-1
	BEGIN
		SELECT @Height = h FROM Day8Tree WHERE x = @Column AND y = @Row;
		SELECT @BL = COUNT(*) FROM Day8Tree WHERE y = @Row AND x < @Column AND h >= @Height;
		SELECT @BR = COUNT(*) FROM Day8Tree WHERE y = @Row AND x > @Column AND h >= @Height;
		SELECT @BU = COUNT(*) FROM Day8Tree WHERE x = @Column AND y < @Row AND h >= @Height;
		SELECT @BD = COUNT(*) FROM Day8Tree WHERE x = @Column AND y > @Row AND h >= @Height;
		SELECT @RL = @Column-ISNULL(MAX(x), 0)        FROM Day8Tree WHERE y = @Row    AND x < @Column AND h >= @Height;
		SELECT @RR = ISNULL(MIN(x), @Width-1)-@Column FROM Day8Tree WHERE y = @Row    AND x > @Column AND h >= @Height;
		SELECT @RU = @Row-ISNULL(MAX(y), 0)           FROM Day8Tree WHERE x = @Column AND y < @Row    AND h >= @Height;
		SELECT @RD = ISNULL(MIN(y), @MaxRow)-@Row     FROM Day8Tree WHERE x = @Column AND y > @Row    AND h >= @Height;
		IF @BL = 0 OR @BR = 0 OR @BU = 0 OR @BD = 0
			SELECT @Visible = 1;
		ELSE
			SELECT @Visible = 0;
		UPDATE Day8Tree SET Visible = @Visible, ScenicScore = (@RL * @RR * @RU * @RD) WHERE x = @Column AND y = @Row;
		SELECT @Column = @Column + 1;
	END;
	SELECT @Row = @Row + 1;
END;

SELECT COUNT(*) AS Puzzle1 FROM Day8Tree WHERE Visible = 1;
SELECT MAX(ScenicScore) AS Puzzle2 FROM Day8Tree;
