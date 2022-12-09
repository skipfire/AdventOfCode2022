var fileContent = File.ReadAllText($"D:\\GitHub\\AdventOfCode2022\\day-6\\{Environment.MachineName}.txt");
var mark4 = 0;
var mark14 = 0;
for(var i = 0; i < fileContent.Length - 13; i++)
{
    if (mark4 == 0)
    {
        var c4 = fileContent.Substring(i, 4).ToCharArray();
        if (c4.Distinct().Count() == 4)
            mark4 = i + 4;
    }

    if (mark14 == 0)
    {
        var c14 = fileContent.Substring(i, 14).ToCharArray();
        if (c14.Distinct().Count() == 14)
            mark14 = i + 14;
    }
}
Console.WriteLine("Puzzle 1: " + mark4);
Console.WriteLine("Puzzle 2: " + mark14);
