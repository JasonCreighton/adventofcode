module Day2

open Xunit

let parseInput (str : string) =
    str.Split(System.Environment.NewLine.ToCharArray(), System.StringSplitOptions.RemoveEmptyEntries)
    |> Array.map (fun s -> Array.map int (s.Split(' ', '\t')))

let part1 = Array.sumBy (fun row -> (Array.max row) - (Array.min row))
let part2 (ary : int[][]) =
    Array.sumBy (fun row ->
        Array.allPairs row row
        |> Array.filter (fun (a, b) -> a <> b && a % b = 0)
        |> Array.exactlyOne
        |> (fun (a, b) -> a / b)
    ) ary

[<Fact>]
let testExamples () =
    let exampleInput1 = "\
        5 1 9 5\n\
        7 5 3\n\
        2 4 6 8\n\
    "
    let exampleInput2 = "\
        5 9 2 8\n\
        9 4 7 3\n\
        3 8 6 5\n\
    "
    Assert.Equal(18, parseInput exampleInput1 |> part1)
    Assert.Equal(9, parseInput exampleInput2 |> part2)

[<Fact>]
let testPuzzleInput () =
    let table = System.IO.File.ReadAllText("../../../inputs/day2.txt").Trim() |> parseInput
    Assert.Equal(45351, part1 table)
    Assert.Equal(275, part2 table)