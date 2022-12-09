var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-1\\{Environment.MachineName}.txt");
var elfCalories = new List<int>();
var currentCalories = 0;
foreach (var line in lines)
{
    if (string.IsNullOrWhiteSpace(line))
    {
        elfCalories.Add(currentCalories);
        currentCalories = 0;
    }
    else
        currentCalories += int.Parse(line);
}
elfCalories.Add(currentCalories);
Console.WriteLine("Puzzle 1: " + elfCalories.Max());
Console.WriteLine("Puzzle 2: " + elfCalories.OrderByDescending(e => e).Take(3).Sum());
