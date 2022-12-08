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
    {
        tree.IsVisible = true; //The tree is on the edge so it is visible.
        tree.ScenicScore = 0; //Trees on the edge have a 0 for one direction, making the scneic result always 0.
    }
    else
    {
        //ToList gets rid of multiple enumeration warning
        //Get all blockers of this tree
        var treeBlockers = trees.Where(t => ( t.y.Equals(tree.y) || t.x.Equals(tree.x) ) && t.h >= tree.h).ToList();
        //Get the blockers each direction
        var blockersLeft = treeBlockers.Where(t => t.y.Equals(tree.y) && t.x < tree.x).ToList();
        var blockersRight = treeBlockers.Where(t => t.y.Equals(tree.y) && t.x > tree.x).ToList();
        var blockersUp = treeBlockers.Where(t => t.x.Equals(tree.x) && t.y < tree.y).ToList();
        var blockersDown = treeBlockers.Where(t => t.x.Equals(tree.x) && t.y > tree.y).ToList();
        //If the tree has blockers in all directions it is not visible.
        tree.IsVisible = !( blockersDown.Any() && blockersUp.Any() && blockersRight.Any() && blockersLeft.Any() );

        //Get range to blocker tree each direction
        var rangeLeft = tree.x - (blockersLeft.Any() ? blockersLeft.Max(t => t.x) : 0);
        var rangeRight = (blockersRight.Any() ? blockersRight.Min(t => t.x) : maxX) - tree.x;
        var rangeUp = tree.y - (blockersUp.Any() ? blockersUp.Max(t => t.y) : 0);
        var rangeDown = (blockersDown.Any() ? blockersDown.Min(t => t.y) : maxY) - tree.y;
        //Get the scenic score
        tree.ScenicScore = rangeLeft * rangeRight * rangeUp * rangeDown;
    }
}

Console.WriteLine("Puzzle 1: " + trees.Count(t => t.IsVisible));
Console.WriteLine("Puzzle 2: " + trees.Max(t => t.ScenicScore));

class Tree
{
    public int x { get; set; }
    public int y { get; set; }
    public int h { get; set; }
    public bool IsVisible { get; set; } = false;
    public int ScenicScore { get; set; }

    public Tree(int x, int y, char h)
    {
        this.x = x;
        this.y = y;
        this.h = int.Parse(h.ToString());
    }
}