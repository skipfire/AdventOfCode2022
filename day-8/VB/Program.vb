Imports System.IO

Module Program
    Sub Main()
        Dim fileContent = File.ReadAllLines($"D:\\GitHub\\AdventOfCode2022\\day-8\\{Environment.MachineName}.txt")
        Dim trees = New List(Of Tree)
        For y = 0 To (fileContent.Length - 1)
            Dim row = fileContent(y).ToCharArray()
            For x = 0 To (row.Length - 1)
                trees.Add(New Tree(x, y, row(x)))
            Next x
        Next y
        Dim maxX = trees.Max(Function(t) t.x)
        Dim maxY = trees.Max(Function(t) t.y)
        For Each tree In trees
            If tree.x = 0 OrElse tree.y = 0 OrElse tree.x = maxX OrElse tree.y = maxY Then
                tree.IsVisible = True
                tree.ScenicScore = 0
            Else
                Dim treeBlockers = trees.Where(Function(t) (t.y.Equals(tree.y) OrElse t.x.Equals(tree.x)) AndAlso t.h >= tree.h).ToList()
                Dim blockersLeft = treeBlockers.Where(Function(t) t.y.Equals(tree.y) AndAlso t.x < tree.x).ToList()
                Dim blockersRight = treeBlockers.Where(Function(t) t.y.Equals(tree.y) AndAlso t.x > tree.x).ToList()
                Dim blockersUp = treeBlockers.Where(Function(t) t.x.Equals(tree.x) AndAlso t.y < tree.y).ToList()
                Dim blockersDown = treeBlockers.Where(Function(t) t.x.Equals(tree.x) AndAlso t.y > tree.y).ToList()
                tree.IsVisible = Not (blockersDown.Any() AndAlso blockersUp.Any() AndAlso blockersRight.Any() AndAlso blockersLeft.Any())

                Dim rangeLeft = tree.x - If(blockersLeft.Any(), blockersLeft.Max(Function(t) t.x), 0)
                Dim rangeRight = If(blockersRight.Any(), blockersRight.Min(Function(t) t.x), maxX) - tree.x
                Dim rangeUp = tree.y - If(blockersUp.Any(), blockersUp.Max(Function(t) t.y), 0)
                Dim rangeDown = If(blockersDown.Any(), blockersDown.Min(Function(t) t.y), maxY) - tree.y
                tree.ScenicScore = rangeLeft * rangeRight * rangeUp * rangeDown
            End If
        Next tree
        Console.WriteLine("Puzzle 1: " & trees.Where(Function(t) t.IsVisible).Count())
        Console.WriteLine("Puzzle 2: " & trees.Max(Function(t) t.ScenicScore))
        End
    End Sub

End Module

Public Class Tree
    Public x As Integer
    Public y As Integer
    Public h As Integer
    Public IsVisible As Boolean = False
    Public ScenicScore As Integer

    Public Sub New(x As Integer, y As Integer, h As Char)
        Me.x = x
        Me.y = y
        Me.h = Integer.Parse(h.ToString())
    End Sub
End Class
