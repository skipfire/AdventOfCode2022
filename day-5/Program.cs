using System.Linq;

var puzzleVersion = 2;
var fileContent = File.ReadAllLines("D:\\GitHub\\AdventOfCode2022\\day-5\\input.txt");
var stacks = new Dictionary<int, List<string>>();
var runCommands = false;
foreach (var line in fileContent) {
    if (runCommands) {
        var commandParts = line.Split(' ');
        var crates = Convert.ToInt16(commandParts[1]);
        var sourceKey = Convert.ToInt16(commandParts[3]);
        var targetKey = Convert.ToInt16(commandParts[5]);
        if (puzzleVersion == 1)
        {
            for (var i = 0; i < crates; i++)
            {
                stacks[targetKey].Add(stacks[sourceKey].Last());
                stacks[sourceKey].RemoveAt(stacks[sourceKey].Count - 1);
            }
        }
        else if (puzzleVersion == 2)
        {
            stacks[targetKey].AddRange(stacks[sourceKey].Skip(stacks[sourceKey].Count - crates).Take(crates));
            stacks[sourceKey].RemoveRange(stacks[sourceKey].Count - crates, crates);
        }
    } else {
        if (string.IsNullOrWhiteSpace(line)) {
            foreach (var stack in stacks)
                stack.Value.Reverse();
            runCommands = true;
            continue;
        }

        var splitLine = line + " ";
        var stackNumber = 0;
        for (var i = 0; i < splitLine.Length; i += 4) {
            stackNumber += 1;
            if (!stacks.ContainsKey(stackNumber))
                stacks.Add(stackNumber, new List<string>());
            var crate = splitLine.Substring(i, 4);
            if (!string.IsNullOrWhiteSpace(crate) && crate.Contains("["))
                stacks[stackNumber].Add(crate.Replace("[", "").Replace("]", ""));
        }
    }
}

foreach (var stack in stacks) {
    Console.Write(stack.Value.Last());
}