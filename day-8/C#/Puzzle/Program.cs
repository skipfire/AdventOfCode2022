var fileContent = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-8\\{Environment.MachineName}.txt");
var trees = new List<Tree>();
for (var y = 0; y < fileContent.Length; y++)
{
    var row = fileContent[y].ToCharArray();
    for (var x = 0; x < row.Length; x++)
        trees.Add(new Tree(x, y, row[x]));
}

var maxX = trees.Max(t => t.x);
var maxY = trees.Max(t => t.y);
foreach (var tree in trees)
{
    if (tree.x == 0 || tree.y == 0 || tree.x == maxX || tree.y == maxY)
        tree.IsVisible = true; //The tree is on the edge so it is visible.
    else
    {
        var treeBlockers = trees.Where(t => ( t.y.Equals(tree.y) || t.x.Equals(tree.x) ) && t.h >= tree.h).ToList(); //ToList gets rid of multiple enumeration warning
        var blockedLeft = treeBlockers.Any(t => t.y.Equals(tree.y) && t.x < tree.x);
        var blockedRight = treeBlockers.Any(t => t.y.Equals(tree.y) && t.x > tree.x);
        var blockedUp = treeBlockers.Any(t => t.x.Equals(tree.x) && t.y < tree.y);
        var blockedDown = treeBlockers.Any(t => t.x.Equals(tree.x) && t.y > tree.y);
        tree.IsVisible = !( blockedDown && blockedUp && blockedRight && blockedLeft );
    }
}

Console.WriteLine("Puzzle 1: " + trees.Count(t => t.IsVisible));

class Tree
{
    public int x { get; set; }
    public int y { get; set; }
    public int h { get; set; }
    public bool IsVisible { get; set; } = false;

    public Tree(int x, int y, char h)
    {
        this.x = x;
        this.y = y;
        this.h = int.Parse(h.ToString());
    }
}