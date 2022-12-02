IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'AdventOfCode2022')
BEGIN
	CREATE DATABASE AdventOfCode2022;
END;
GO
USE AdventOfCode2022;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day2')
BEGIN
	DROP TABLE Day2;
END;
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day2Input')
BEGIN
	DROP TABLE Day2Input;
END;
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE [name] = 'Day2Rps')
BEGIN
	DROP TABLE Day2Rps;
END;
GO
CREATE TABLE Day2Rps ([Name] VARCHAR(10), [Value] INT, Letter1 CHAR(1), Letter2 CHAR(1), Beats VARCHAR(10));
CREATE TABLE Day2 (Them VARCHAR(10), Me VARCHAR(10), MeValue INT, Winner VARCHAR(4) NULL, MeScore INT NULL);
CREATE TABLE Day2Input (Them VARCHAR(10), Me VARCHAR(10));
INSERT INTO Day2Rps VALUES ('Rock', 1, 'A', 'X', 'Scissors'), ('Paper', 2, 'B', 'Y', 'Rock'), ('Scissors', 3, 'C', 'Z', 'Paper');
--Import data
BULK INSERT Day2Input FROM 'd:\GitHub\AdventOfCode2022\day-2\input.txt' WITH (FIELDTERMINATOR = ' ', ROWTERMINATOR = '\n');
--Clean and replace to readable values
UPDATE Day2Input SET Them = TRIM(Them), Me = TRIM(Me);
UPDATE i
SET Them = rps1.[Name], Me = rps2.[Name]
FROM Day2Input i
INNER JOIN Day2Rps rps1 ON rps1.Letter1 = i.Them
INNER JOIN Day2Rps rps2 ON rps2.Letter2 = i.Me;
--Calculate and insert scores
INSERT INTO Day2 (Them, Me, MeValue, MeScore)
SELECT Them, Me, r.[Value] As MeValue, r.[Value] + CASE WHEN Them = r.Beats THEN 6 WHEN Them = Me THEN 3 ELSE 0 END As MeScore
FROM Day2Input i
INNER JOIN Day2Rps r ON i.Me = r.[Name];
--Get Result
SELECT SUM(MeScore) As MeTotal FROM Day2;
