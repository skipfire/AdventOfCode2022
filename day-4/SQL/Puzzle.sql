--Start off ensuring objects are correct
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day4')
BEGIN
	DROP TABLE Day4;
END;

CREATE TABLE Day4 (E1 VARCHAR(MAX), E2 VARCHAR(MAX));
--Import the data, 0x0a is a line feed character
BULK INSERT Day4 FROM 'd:\GitHub\AdventOfCode2022\day-4\input.txt' WITH (FIELDTERMINATOR=',', ROWTERMINATOR = '0x0a');
--Add columns for comparison
ALTER TABLE Day4 ADD E1MIN INT;
ALTER TABLE Day4 ADD E1MAX INT;
ALTER TABLE Day4 ADD E2MIN INT;
ALTER TABLE Day4 ADD E2MAX INT;
--Update the new columns with data
--SELECT CHARINDEX('-', E1) FROM Day4 
UPDATE Day4 
SET E1MIN = SUBSTRING(E1, 1, CHARINDEX('-', E1)-1), 
	E1MAX = SUBSTRING(E1, CHARINDEX('-', E1) + 1, LEN(E1) - CHARINDEX('-', E1)),
	E2MIN = SUBSTRING(E2, 1, CHARINDEX('-', E2)-1), 
	E2MAX = SUBSTRING(E2, CHARINDEX('-', E2) + 1, LEN(E2) - CHARINDEX('-', E2)) 
FROM Day4;

SELECT COUNT(*) As Puzzle1
FROM Day4 
WHERE 
	E1MIN >= E2MIN AND E1MAX <= E2MAX OR
	E2MIN >= E1MIN AND E2MAX <= E1MAX;

SELECT COUNT(*) As Puzzle2
FROM Day4 
WHERE 
	E1MIN >= E2MIN AND E1MIN <= E2MAX OR
	E1MAX >= E2MIN AND E1MAX <= E2MAX OR
	E2MIN >= E1MIN AND E2MIN <= E1MAX OR
	E2MAX >= E1MIN AND E2MAX <= E1MAX;