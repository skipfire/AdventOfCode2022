var headPositions = new List<Coordinate>();
var tailPositions = new List<Coordinate>();
var headPosition = new Coordinate(0, 0);
var tailPosition = new Coordinate(0, 0);
headPositions.Add(headPosition);
tailPositions.Add(tailPosition);
var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-9\\{Environment.MachineName}.txt");
foreach (var line in lines)
{
    var parts = line.Split(' ');
    var direction = parts[0];
    var steps = Convert.ToInt32(parts[1]);
    for (var i = 0; i < steps; i++)
    {
        var tailMoveX = 0;
        var tailMoveY = 0;
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
        if (headPosition.x - tailPosition.x > 1)
            tailMoveX = 1;
        else if (headPosition.x - tailPosition.x < -1)
            tailMoveX = -1;
        else if (headPosition.y - tailPosition.y > 1)
            tailMoveY = 1;
        else if (headPosition.y - tailPosition.y < -1)
            tailMoveY = -1;
        if (tailMoveX != 0 || tailMoveY != 0)
        {
            tailPosition = new Coordinate(tailPosition.x + tailMoveX, tailPosition.y + tailMoveY);
            if (tailMoveX != 0 && tailPosition.y != headPosition.y)
                tailPosition.y = headPosition.y;
            if (tailMoveY != 0 && tailPosition.x != headPosition.x)
                tailPosition.x = headPosition.x;
            tailPositions.Add(tailPosition);
        }
    }
}



Console.WriteLine("Puzzle 1: " + tailPositions.Select(t=>t.x + "," + t.y).Distinct().Count());

class Coordinate
{
    public int x; 
    public int y;

    public Coordinate(int x, int y) {
        this.x = x;
        this.y = y;
    }
}