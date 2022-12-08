IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day2Input')
BEGIN
	DROP TABLE Day2Input;
END;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Permutations')
BEGIN
	DROP TABLE Permutations;
END;
GO
CREATE TABLE Day2Input (Them VARCHAR(10), Result VARCHAR(10));
BULK INSERT Day2Input FROM 'd:\GitHub\AdventOfCode2022\day-2\input.txt' WITH (FIELDTERMINATOR = ' ', ROWTERMINATOR = '\n');
--Clean and replace to readable values
UPDATE Day2Input SET Them = TRIM(Them), Result = TRIM(Result);

CREATE TABLE Permutations (Them CHAR(1), Result CHAR(1), Score INT);
INSERT INTO Permutations VALUES 
	('A', 'X', 3+0),
	('B', 'X', 1+0),
	('C', 'X', 2+0),
	('A', 'Y', 1+3),
	('B', 'Y', 2+3),
	('C', 'Y', 3+3),
	('A', 'Z', 2+6),
	('B', 'Z', 3+6),
	('C', 'Z', 1+6);
SELECT SUM(Score)
FROM (
	SELECT Score
	FROM Day2Input i
	INNER JOIN Permutations p ON i.Them = p.Them AND i.Result = p.Result) as ivw5;