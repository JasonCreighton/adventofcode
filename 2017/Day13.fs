module Day13

open Xunit

let scannerPosition range time =
    let period = range + (range - 2)
    let timeInPeriod = time % period
    if timeInPeriod < range then
        timeInPeriod
    else
        period - timeInPeriod

[<Fact>]
let testScannerPosition () =
    let times = Array.init 10 id
    Assert.Equal<int>([|0; 1; 2; 1; 0; 1; 2; 1; 0; 1;|], Array.map (scannerPosition 3) times)
    Assert.Equal<int>([|0; 1; 2; 3; 4; 3; 2; 1; 0; 1;|], Array.map (scannerPosition 5) times)

let severity (depth, range) =
    if scannerPosition range depth = 0 then
        depth * range
    else
        0

let totalSeverity = Array.sumBy severity

let parseInput (str : string) =
    let lines = str.Split(System.Environment.NewLine.ToCharArray(), System.StringSplitOptions.RemoveEmptyEntries)
    Array.map (fun (line : string) -> let parts = line.Split(": ") in (int parts[0], int parts[1])) lines

[<Fact>]
let testExamples () =
    let exampleInput = """
0: 3
1: 2
4: 4
6: 4
"""
    let ranges = parseInput exampleInput
    Assert.Equal(24, totalSeverity ranges)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day13.txt")
    let ranges = parseInput puzzleInput
    Assert.Equal(1840, totalSeverity ranges)