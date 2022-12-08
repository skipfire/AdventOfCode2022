var lines = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-2\\{Environment.MachineName}.txt");
var throws = new List<Throws>();

foreach (var line in lines)
{
    var parts = line.Split(' ');
    throws.Add(new Throws {Them = parts[0], Guide = parts[1] });
}

Console.WriteLine("Puzzle 1: " + throws.Sum(t=>t.GetMyScore1()));
Console.WriteLine("Puzzle 2: " + throws.Sum(t => t.GetMyScore2()));

class Throws
{
    private static readonly Dictionary<string, string> theyWin = new();
    private static readonly Dictionary<string, string> iWin = new();
    private static readonly Dictionary<string, string> ties = new();

    static Throws()
    {
        theyWin.Add("A", "Z"); //Rock beats Scissors
        theyWin.Add("B", "X"); //Paper beats Rock
        theyWin.Add("C", "Y"); //Scissors beats Paper
        iWin.Add("A", "Y"); //Rock beats Scissors
        iWin.Add("B", "Z"); //Paper beats Rock
        iWin.Add("C", "X"); //Scissors beats Paper
        ties.Add("A", "X"); //Rock
        ties.Add("B", "Y"); //Paper
        ties.Add("C", "Z"); //Scissors
    }

    public string Them { get; set; }
    public string Guide { get; set; }

    public int GetMyScore1()
    {
        int throwScore, winScore;
        switch (Guide)
        {
            case "X": //Rock
                throwScore = 1;
                break;
            case "Y": //Paper
                throwScore = 2;
                break;
            case "Z": //Scissors
                throwScore = 3;
                break;
            default:
                throwScore = 0;
                break;
        }

        if (ties[Them].Equals(Guide))
            winScore = 3; //Tie
        else if (theyWin[Them].Equals(Guide))
            winScore = 0; //Lose
        else
            winScore = 6; //Win

        return throwScore + winScore;
    }

    public int GetMyScore2()
    {
        int throwScore, winScore;
        string myThrow = "";
        switch (Guide)
        {
            case "Z":
                winScore = 6; //Win
                myThrow = iWin[Them];
                break;
            case "Y":
                winScore = 3; //Tie
                myThrow = ties[Them];
                break;
            case "X":
            default:
                winScore = 0; //Lose
                myThrow = theyWin[Them];
                break;
        }

        switch (myThrow) {
            case "X": //Rock
                throwScore = 1;
                break;
            case "Y": //Paper
                throwScore = 2;
                break;
            case "Z": //Scissors
                throwScore = 3;
                break;
            default:
                throwScore = 0;
                break;
        }

        return throwScore + winScore;
    }
}