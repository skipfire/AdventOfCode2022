--Start off ensuring objects are correct
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day3')
BEGIN
	DROP TABLE Day3;
END;
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day3Values')
BEGIN
	DROP TABLE Day3Values;
END;

CREATE TABLE Day3 (Line VARCHAR(400));
CREATE TABLE Day3Values (Letter CHAR(1), [Value] INT);
--Populate the letter/value lookup table
DECLARE @charIndex INT, @charIndexOffset INT, @charIndexMax INT;
SELECT @charIndex = ASCII('a'), @charIndexOffset = ASCII('a') - 1, @charIndexMax = ASCII('a') + 25;
WHILE @charIndex <= @charIndexMax
BEGIN
	INSERT INTO Day3Values (Letter, [Value]) SELECT CHAR(@charIndex), @charIndex - @charIndexOffset;
	SELECT @charIndex = @charIndex + 1;
END;
SELECT @charIndex = ASCII('A'), @charIndexOffset = ASCII('A') - 1 - 26, @charIndexMax = ASCII('A') + 25;
WHILE @charIndex <= @charIndexMax
BEGIN
	INSERT INTO Day3Values (Letter, [Value]) SELECT CHAR(@charIndex), @charIndex - @charIndexOffset;
	SELECT @charIndex = @charIndex + 1;
END;
--Do the bulk insert
BULK INSERT Day3 FROM 'd:\GitHub\AdventOfCode2022\day-3\input.txt' WITH (ROWTERMINATOR = '\n');
--Add the extra columns we need to the table
ALTER TABLE Day3 ADD ID INT IDENTITY(0,1);
ALTER TABLE Day3 ADD GroupNumber INT;
ALTER TABLE Day3 ADD C1 VARCHAR(200);
ALTER TABLE Day3 ADD C2 VARCHAR(200);
ALTER TABLE Day3 ADD Item CHAR(1);
ALTER TABLE Day3 ADD Badge CHAR(1);
--Update the easy values into those extra columns
UPDATE Day3 SET GroupNumber = ID / 3, C1 = LEFT(Line, LEN(Line)/2), C2 = RIGHT(Line, LEN(Line)/2);

--Iterate over every record
DECLARE @Id INT = 0, @MaxId INT, @C1 VARCHAR(200), @C2 VARCHAR(200), @Line VARCHAR(400), @pos INT, @c CHAR(1), @Next1 VARCHAR(200), @Next2 VARCHAR(200);
SELECT @MaxId = MAX(ID) FROM Day3;
WHILE @Id <= @MaxId
BEGIN
	SELECT @C1 = C1, @C2 = C2, @Line = Line, @c = NULL, @pos = 1 FROM Day3 WHERE ID = @Id;
	--For the first in each group of 3, get the other 2 records, this is part of Puzzle 2 logic
	IF @ID % 3 = 0
	BEGIN
		SELECT @Next1 = Line FROM Day3 WHERE ID = @Id + 1;
		SELECT @Next2 = Line FROM Day3 WHERE ID = @Id + 2;
	END;
	--Iterate over every letter in compartment 1
	WHILE @pos <= LEN(@Line)
	BEGIN
		SELECT @c = SUBSTRING(@Line, @pos, 1);
		--BEGIN Puzzle 1 check
		IF @pos <= LEN(@c1) --This ensures the Puzzle 1 check is only happening from compartment 1 to compartment 2, not comparing compartment 2 to itself
		BEGIN
			IF CHARINDEX(@c, @C2 COLLATE Latin1_General_100_CS_AS) > 0
			BEGIN
				UPDATE Day3 SET Item = @c WHERE ID = @Id;
			END;
		END;
		--END Puzzle 1 check
		--BEGIN Puzzle 2 check
		IF @ID % 3 = 0
		BEGIN
			IF CHARINDEX(@c, @Next1 COLLATE Latin1_General_100_CS_AS) > 0 AND CHARINDEX(@c, @Next2 COLLATE Latin1_General_100_CS_AS) > 0
			BEGIN
				UPDATE Day3 SET Badge = @c WHERE ID = @Id;
			END;
		END;
		--END Puzzle 2 check
		SELECT @pos = @pos + 1;
	END;
	SET @Id = @Id + 1;
END;

SELECT SUM([Value]) As Puzzle1
FROM Day3 d
INNER JOIN Day3Values v ON d.Item = v.Letter COLLATE Latin1_General_100_CS_AS;

SELECT SUM([Value]) As Puzzle2
FROM Day3 d
INNER JOIN Day3Values v ON d.Badge = v.Letter COLLATE Latin1_General_100_CS_AS
WHERE Badge IS NOT NULL;

