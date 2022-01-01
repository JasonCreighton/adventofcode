module Day1

open Xunit

let circularPairs dist ary =
    let len = Array.length ary
    Array.init len (fun i -> (ary[i], ary[(i + dist) % len]))

let stringToDigits str = Seq.toArray str |> Array.map (fun ch -> int ch - int '0')

let captchaSolution dist str =
    stringToDigits str
    |> circularPairs dist
    |> Array.sumBy (fun (a, b) -> if a = b then a else 0)

let part1 str = captchaSolution 1 str
let part2 str = captchaSolution ((String.length str) / 2) str

[<Fact>]
let testExamples () =    
    Assert.Equal(part1 "1122", 3)
    Assert.Equal(part1 "1111", 4)
    Assert.Equal(part1 "1234", 0)
    Assert.Equal(part1 "91212129", 9)

    Assert.Equal(part2 "1212", 6)
    Assert.Equal(part2 "1221", 0)
    Assert.Equal(part2 "123425", 4)
    Assert.Equal(part2 "123123", 12)
    Assert.Equal(part2 "12131415", 4)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day1.txt").Trim()
    Assert.Equal(part1 puzzleInput, 1393)
    Assert.Equal(part2 puzzleInput, 1292)