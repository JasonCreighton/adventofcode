module Day10

open Xunit

let reverseSegment ary startIndex length =
    for i = 0 to (length / 2) - 1 do
        let a = (startIndex + i) % Array.length ary
        let b = (startIndex + length - 1 - i) % Array.length ary
        let tmp = ary[a]
        ary[a] <- ary[b]
        ary[b] <- tmp

let knotHash ary lengths =
    let mutable i = 0
    let mutable skipSize = 0
    for length in lengths do
        reverseSegment ary i length
        i <- (i + length + skipSize) % Array.length ary
        skipSize <- skipSize + 1

[<Fact>]
let testExamples () =
    let lengths = [3; 4; 1; 5;]
    let ary = Array.init 5 id
    knotHash ary lengths
    Assert.Equal<int>([|3; 4; 2; 1; 0;|], ary)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day10.txt")
    let lengths = puzzleInput.Split(',') |> Array.map int
    let ary = Array.init 256 id
    knotHash ary lengths
    Assert.Equal(23874, ary[0] * ary[1])