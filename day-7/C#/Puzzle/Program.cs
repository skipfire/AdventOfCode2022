var fileContent = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-7\\{Environment.MachineName}.txt");
var depth = 0;
var wd = new Stack<string>();
var sizes = new List<ObjectSize>();

foreach (var line in fileContent)
{
    if (line.Equals("$ cd ..")) 
    {
        wd.Pop();
        depth--;
    } 
    else if (line.StartsWith("$ cd ")) 
    {
        var parent = wd.Any() ? wd.Peek() : "";
        var newDir = parent + line.Replace("$ cd ", "");
        if (!newDir.EndsWith("/")) newDir += "/";
        wd.Push(newDir);
        depth++;
        sizes.Add(new ObjectSize{Depth = depth, Parent = parent, Path = newDir});
    } 
    else if (line.Equals("$ ls") || line.StartsWith("dir "))
    {
        //Do Nothing
    }
    else
    {
        var parent = wd.Any() ? wd.Peek() : "";
        var parts = line.Split(" ");
        var size = Convert.ToInt64(parts[0]);
        var file = parent + parts[1];
        sizes.Add(new ObjectSize { Depth = depth + 1, Parent = parent, Path = file, Size = size});
    }
}

var maxDepth = sizes.Max(s => s.Depth);
for (var i = maxDepth; i >= 0; i--)
{
    var toCalculate = sizes.Where(s => s.Depth.Equals(i) && s.Size.Equals(0));
    foreach (var size in toCalculate)
    {
        size.Size = sizes.Where(s=>s.Parent.Equals(size.Path)).Sum(s => s.Size);
    }
}

Console.WriteLine("Puzzle 1: " + sizes.Where(s => s.Path.EndsWith("/") && s.Size <= 100000).Sum(s => s.Size));

var totalSpace = 70000000;
var usedSpace = sizes.FirstOrDefault(s => s.Path.Equals("/")).Size;
var freeSpace = totalSpace - usedSpace;
var requiredSpace = 30000000 - freeSpace;
var bigEnough = sizes.Where(s => s.Size > requiredSpace && s.Path.EndsWith("/"));
Console.WriteLine("Puzzle 2: " + bigEnough.Min(s => s.Size));

class ObjectSize
{
    public string Parent { get; set; }
    public string Path { get; set; }
    public int Depth { get; set; }
    public long Size { get; set; }
}