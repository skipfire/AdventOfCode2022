var headPositions = new List<Coordinate>();
var knotPositions = new Dictionary<int, List<Coordinate>>();
var headPosition = new Coordinate(0, 0);
var knotPosition = new Dictionary<int, Coordinate>();
headPositions.Add(headPosition);
for (var i = 1; i <= 9; i++)
{
    knotPosition.Add(i, new Coordinate(0,0));
    knotPositions.Add(i, new List<Coordinate>());
    knotPositions[i].Add(knotPosition[i]);
}
var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-9\\{Environment.MachineName}.txt");
foreach (var line in lines)
{
    var parts = line.Split(' ');
    var direction = parts[0];
    var steps = Convert.ToInt32(parts[1]);
    for (var i = 0; i < steps; i++)
    {
        switch (direction)
        {
            case "U":
                headPosition = new Coordinate(headPosition.x, headPosition.y + 1);
                break;
            case "D":
                headPosition = new Coordinate(headPosition.x, headPosition.y - 1);
                break;
            case "L":
                headPosition = new Coordinate(headPosition.x - 1, headPosition.y);
                break;
            case "R":
                headPosition = new Coordinate(headPosition.x + 1, headPosition.y);
                break;
        }
        headPositions.Add(headPosition);
        MoveFollower(headPosition, 1);
    }
}

Console.WriteLine("Puzzle 1: " + knotPositions[1].Select(t=>t.x + "," + t.y).Distinct().Count());
Console.WriteLine("Puzzle 2: " + knotPositions[9].Select(t => t.x + "," + t.y).Distinct().Count());

void MoveFollower(Coordinate leader, int knot)
{
    var moveX = 0;
    var moveY = 0;
    if (leader.x - knotPosition[knot].x > 1)
        moveX = 1;
    else if (leader.x - knotPosition[knot].x < -1)
        moveX = -1;
    else if (leader.y - knotPosition[knot].y > 1)
        moveY = 1;
    else if (leader.y - knotPosition[knot].y < -1)
        moveY = -1;
    if (moveX != 0 || moveY != 0) {
        knotPosition[knot] = new Coordinate(knotPosition[knot].x + moveX, knotPosition[knot].y + moveY);
        if (moveX != 0 && knotPosition[knot].y != leader.y)
            knotPosition[knot].y = leader.y;
        if (moveY != 0 && knotPosition[knot].x != leader.x)
            knotPosition[knot].x = leader.x;
        knotPositions[knot].Add(knotPosition[knot]);
        if (knot < 9)
            MoveFollower(knotPosition[knot], knot + 1);
    }
}

class Coordinate
{
    public int x; 
    public int y;

    public Coordinate(int x, int y) {
        this.x = x;
        this.y = y;
    }
}