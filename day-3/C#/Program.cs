var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-3\\{Environment.MachineName}.txt");
var elfPacks = new List<ElfPack>();
var elfGroups = new List<ElfGroup>();
var currentElfGroup = new ElfGroup();
var valueDictionary = new Dictionary<char, int>();
for (var i = 1; i <= 26; i++)
{
    valueDictionary.Add((char)(i + 96), i);
    valueDictionary.Add((char)(i + 64), i + 26);
}
foreach (var line in lines)
{
    elfPacks.Add(new ElfPack(line));
    if (currentElfGroup.E1 == null)
        currentElfGroup.E1 = line.ToCharArray();
    else if (currentElfGroup.E2 == null)
        currentElfGroup.E2 = line.ToCharArray();
    else if (currentElfGroup.E3 == null)
    {
        currentElfGroup.E3 = line.ToCharArray();
        elfGroups.Add(currentElfGroup);
        currentElfGroup = new ElfGroup();
    }
}

Console.WriteLine("Puzzle 1: " + elfPacks.Sum(e => valueDictionary[e.DuplicateItem()]));
Console.WriteLine("Puzzle 2: " + elfGroups.Sum(e => valueDictionary[e.BadgeItem()]));

class ElfPack
{
    public char[] Items { get; set; }
    public char[] C1 { get; set; }
    public char[] C2 { get; set; }

    public ElfPack(string items)
    {
        Items = items.ToCharArray();
        C1 = items.Substring(0, items.Length / 2).ToCharArray();
        C2 = items.Substring(items.Length / 2).ToCharArray();
    }

    public char DuplicateItem()
    {
        foreach(var i in C1)
            if (C2.Contains(i))
                return i;
        return ' ';
    }
}

class ElfGroup
{
    public char[] E1 { get; set; }
    public char[] E2 { get; set; }
    public char[] E3 { get; set; }

    public char BadgeItem() {
        foreach (var i in E1)
            if (E2.Contains(i) && E3.Contains(i))
                return i;
        return ' ';
    }
}