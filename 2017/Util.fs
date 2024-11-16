module Util

open Xunit

let splitIntoLines (s : string) =
    s.Split(System.Environment.NewLine.ToCharArray(), System.StringSplitOptions.RemoveEmptyEntries)

let testDay dayNumber runFunc =
    let puzzleInput = System.IO.File.ReadAllText($"../../../data/input{dayNumber}.txt").Trim()
    let (part1Answer, part2Answer) = runFunc puzzleInput
    let (p1String, p2String) = part1Answer |> string, part2Answer |> string

    let expectedAnswers = System.IO.File.ReadAllLines($"../../../data/answers{dayNumber}.txt")
    Assert.Equal(expectedAnswers[0], p1String)
    Assert.Equal(expectedAnswers[1], p2String)

    (p1String, p2String)