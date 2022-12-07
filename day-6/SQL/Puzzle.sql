--Start off ensuring objects are correct
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day6')
BEGIN
	DROP TABLE Day6;
END;
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day6Chars')
BEGIN
	DROP TABLE Day6Chars;
END;

CREATE TABLE Day6 ([Message] VARCHAR(MAX));
CREATE TABLE Day6Chars (C CHAR(1), ID INT IDENTITY(1,1), NextMatch INT);
CREATE INDEX idx_Chars ON Day6Chars (C, ID);
--Import the data, 0x0a is a line feed character
BULK INSERT Day6 FROM 'd:\GitHub\AdventOfCode2022\day-6\input.txt' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0a');
--Populate Chars
DECLARE @pos INT = 1, @len INT, @message VARCHAR(MAX), @c CHAR(1), @Next INT;
SELECT TOP 1 @len = LEN([Message]), @message = [Message] FROM Day6;
WHILE @pos <= @len
BEGIN
	SELECT @c = SUBSTRING(@message, @pos, 1), @pos = @pos + 1;
	INSERT INTO Day6Chars (C) VALUES (@c);
END;
--Find the next instance of the char for each record
SELECT @pos = 1;
WHILE @pos <= @len
BEGIN
	SELECT @Next = MIN(d2.ID)
	FROM Day6Chars d2
	INNER JOIN Day6Chars d1 ON d2.C = d1.C AND d2.ID > d1.ID
	WHERE d1.ID > @pos;

	UPDATE Day6Chars SET NextMatch = @Next WHERE ID = @pos;
	IF @Next > @pos + 14
	BEGIN
		BREAK;
	END;
	PRINT @pos;
	SELECT @pos = @pos + 1;
END;

SELECT MIN(ID) + 4 AS Puzzle1 FROM Day6Chars WHERE NextMatch > ID + 4;
SELECT MIN(ID) + 14 AS Puzzle2 FROM Day6Chars WHERE NextMatch > ID + 14;
