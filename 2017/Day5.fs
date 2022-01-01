module Day5

open Xunit

let stepsToExit part2 jumpOffsets =
    let mutable i = 0
    let mutable steps = 0
    while i >= 0 && i < Array.length jumpOffsets do
        let oldOffset = jumpOffsets[i]
        jumpOffsets[i] <- jumpOffsets[i] + (if part2 && oldOffset >= 3 then -1 else 1)
        i <- i + oldOffset
        steps <- steps + 1
    steps

let part1 = stepsToExit false
let part2 = stepsToExit true

[<Fact>]
let testExamples () =
    let exampleInput = [|0; 3; 0; 1; -3;|]

    let part1Offsets = Array.copy exampleInput
    Assert.Equal(5, part1 part1Offsets)
    Assert.Equal<int>([|2; 5; 0; 1; -2;|], part1Offsets)

    let part2Offsets = Array.copy exampleInput
    Assert.Equal(10, part2 part2Offsets)
    Assert.Equal<int>([|2; 3; 2; 3; -1;|], part2Offsets)

    
[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadLines("../../../inputs/day5.txt") |> Seq.map int |> Seq.toArray
    Assert.Equal(381680, Array.copy puzzleInput |> part1)
    Assert.Equal(29717847, Array.copy puzzleInput |> part2)

