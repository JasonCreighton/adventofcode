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
    Assert.Equal<int>([|0; 1; 0; 1; 0; 1; 0; 1; 0; 1;|], Array.map (scannerPosition 2) times)
    Assert.Equal<int>([|0; 1; 2; 1; 0; 1; 2; 1; 0; 1;|], Array.map (scannerPosition 3) times)
    Assert.Equal<int>([|0; 1; 2; 3; 4; 3; 2; 1; 0; 1;|], Array.map (scannerPosition 5) times)

let caught delay (depth, range) = scannerPosition range (depth + delay) = 0

let severity delay (depth, range) =
    if caught delay (depth, range) then
        depth * range
    else
        0

let totalSeverity delay = Array.sumBy (severity delay)

// Dumb brute force approach
let smallestSafeDelay ranges =
    Seq.initInfinite id
    |> Seq.find (fun delay -> Array.forall (not << caught delay) ranges)

let parseInput (str : string) =
    let lines = str.Split(System.Environment.NewLine.ToCharArray(), System.StringSplitOptions.RemoveEmptyEntries)
    Array.map (fun (line : string) -> let parts = line.Split(": ") in (int parts[0], int parts[1])) lines

let run puzzleInput =
    let ranges = parseInput puzzleInput
    (totalSeverity 0 ranges, smallestSafeDelay ranges)

[<Fact>]
let testExamples () =
    let exampleInput = """
0: 3
1: 2
4: 4
6: 4
"""
    let ranges = parseInput exampleInput
    Assert.Equal(24, totalSeverity 0 ranges)

    // Initial position of example after delaying by 10
    Assert.Equal(2, scannerPosition 3 10)
    Assert.Equal(0, scannerPosition 2 10)
    Assert.Equal(2, scannerPosition 4 10)
    Assert.Equal(2, scannerPosition 4 10)

    Assert.Equal(10, smallestSafeDelay ranges)

[<Fact>]
let testPuzzleInput () = Util.testDay 13 run