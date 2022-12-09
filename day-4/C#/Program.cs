var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-4\\{Environment.MachineName}.txt");
var elfPairs = new List<ElfPair>();
foreach (var line in lines)
{
    var elfs = line.Split(",");
    var elf1 = elfs[0].Split("-");
    var elf2 = elfs[1].Split("-");
    elfPairs.Add(new ElfPair { E1Min = int.Parse(elf1[0]), E1Max = int.Parse(elf1[1]), E2Min = int.Parse(elf2[0]), E2Max = int.Parse(elf2[1]) });
}
Console.WriteLine("Puzzle 1: " + elfPairs.Count(e => e.FullOverlap()));
Console.WriteLine("Puzzle 2: " + elfPairs.Count(e => e.PartialOverlap()));

class ElfPair
{
    public int E1Min { get; set; }
    public int E1Max { get; set; }
    public int E2Min { get; set; }
    public int E2Max { get; set; }

    public bool FullOverlap() 
    {
        return E1Min >= E2Min && E1Max <= E2Max || E2Min >= E1Min && E2Max <= E1Max;
    }

    public bool PartialOverlap()
    {
        return 
            E1Min >= E2Min && E1Min <= E2Max ||
            E1Max >= E2Min && E1Max <= E2Max || 
            E2Min >= E1Min && E2Min <= E1Max || 
            E2Max >= E1Min && E2Max <= E1Max;
    }
}