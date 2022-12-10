var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-10\\{Environment.MachineName}.txt");
var checkCycles = new Dictionary<int, int>();
var cycle = 0;
var signal = 1;
foreach (var line in lines)
{
    var addAmount = 0;
    var commandDuration = 0;
    if (line.Equals("noop"))
        commandDuration = 1;
    else
    {
        commandDuration = 2;
        addAmount = Convert.ToInt32(line.Split(' ')[1]);
    }
    for (var i = 0; i < commandDuration; i++)
    {
        cycle++;
        if (cycle % 40 == 20)
            checkCycles.Add(cycle, signal * cycle);
    }
    signal += addAmount;
}

Console.WriteLine("Puzzle 1: " + checkCycles.Values.Sum()); // >13200
Console.WriteLine("Puzzle 2: " );
