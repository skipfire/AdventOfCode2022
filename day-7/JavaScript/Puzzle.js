class ObjectSize {
    constructor(depth, parent, path, size) {
        this.Depth = depth;
        this.Parent = parent;
        this.Path = path;
        this.Size = size;
    }
}

const fs = require('fs');
const os = require("os");
var hostname = os.hostname();
var fileContent = ""
try {
    fileContent = fs.readFileSync('D:\\GitHub\\AdventOfCode2022\\day-7\\' + hostname + '.txt', 'utf8');
} catch (err) {
    console.error(err);
}

var depth = 0;
var wd = [];
var sizes = [];
var lines = fileContent.split('\n');
var maxDepth = 0;

lines.forEach(line => 
{
    if (line == "$ cd ..")
    {
        wd.pop();
        depth--;
    } 
    else if (line.startsWith("$ cd ")) 
    {
        var parent = wd.length > 0 ? wd[wd.length-1] : "";
        var newDir = parent + line.replace("$ cd ", "");
        if (!newDir.endsWith("/")) newDir += "/";
        wd.push(newDir);
        depth++;
        maxDepth = Math.max(depth, maxDepth);
        sizes.push(new ObjectSize(depth, parent, newDir, 0));
    } 
    else if (line == "$ ls" || line.startsWith("dir "))
    {
        //Do Nothing
    }
    else
    {
        var parent = wd.length > 0 ? wd[wd.length-1] : "";
        var parts = line.split(" ");
        var size = parseInt(parts[0]);
        var file = parent + parts[1];
        sizes.push(new ObjectSize(depth + 1, parent, file, size));
    }
});

for (var i = maxDepth; i >= 0; i--)
{
    var toCalculate = sizes.filter(s => s.Depth == i && s.Size == 0);
    if(toCalculate.length > 0)
    {
        toCalculate.forEach(size =>
        {
            var children = sizes.filter(s=>s.Parent == size.Path);
            children.forEach(child => size.Size += (isNaN(child.Size) ? 0 : child.Size));
        });
    }
}

var puzzle1Sizes = sizes.filter(s => s.Path.endsWith("/") && s.Size <= 100000);
var puzzle1Total = 0;
puzzle1Sizes.forEach(s => puzzle1Total += s.Size)
console.log("Puzzle 1: " + puzzle1Total);

var totalSpace = 70000000;
var usedSpace = sizes.filter(s => s.Path == "/")[0].Size;
var freeSpace = totalSpace - usedSpace;
var requiredSpace = 30000000 - freeSpace;
var bigEnough = sizes.filter(s => s.Size > requiredSpace && s.Path.endsWith("/"));
var sorted = bigEnough.sort((a, b) => { 
    if(a.Size < b.Size) return -1;
    if(a.Size > b.Size) return 1;
    return 0;
});
console.log("Puzzle 2: " + sorted[0].Size);
