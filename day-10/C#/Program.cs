var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-10\\{Environment.MachineName}.txt");
var checkCycles = new Dictionary<int, int>();
var cycle = 0;
var register = 1;
Console.WriteLine("Puzzle 2: ");
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
            checkCycles.Add(cycle, register * cycle);
        var position = (cycle % 40) - 1; //Cycle starts at "first cycle" but row starts at 0
        if (Math.Abs(position - register) <= 1)
            Console.Write("#");
        else
            Console.Write(".");
        if (cycle % 40 == 0)
            Console.WriteLine();
    }
    register += addAmount;
}

Console.WriteLine();
Console.WriteLine("Puzzle 1: " + checkCycles.Values.Sum());