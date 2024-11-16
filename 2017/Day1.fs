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

let run puzzleInput = (part1 puzzleInput, part2 puzzleInput)

[<Fact>]
let testExamples () =    
    Assert.Equal(3, part1 "1122")
    Assert.Equal(4, part1 "1111")
    Assert.Equal(0, part1 "1234")
    Assert.Equal(9, part1 "91212129")
    
    Assert.Equal(6, part2 "1212")
    Assert.Equal(0, part2 "1221")
    Assert.Equal(4, part2 "123425")
    Assert.Equal(12, part2 "123123")
    Assert.Equal(4, part2 "12131415")

[<Fact>]
let testPuzzleInput () = Util.testDay 1 run