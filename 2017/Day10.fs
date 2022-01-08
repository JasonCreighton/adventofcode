module Day10

open Xunit

type KnotHashState = {
    ary: int[]
    lengths: int[]
    mutable i: int
    mutable skipSize: int
}

let newState size lengths = { ary = Array.init size id; lengths = lengths; i = 0; skipSize = 0 }

let reverseSegment ary startIndex length =
    for i = 0 to (length / 2) - 1 do
        let a = (startIndex + i) % Array.length ary
        let b = (startIndex + length - 1 - i) % Array.length ary
        let tmp = ary[a]
        ary[a] <- ary[b]
        ary[b] <- tmp

let knotHashRound st =
    for length in st.lengths do
        reverseSegment st.ary st.i length
        st.i <- (st.i + length + st.skipSize) % Array.length st.ary
        st.skipSize <- st.skipSize + 1

let knotHash (str : string) =
    let st = newState 256 (Array.append (Seq.map int str |> Seq.toArray) [|17; 31; 73; 47; 23;|])
    for _ = 1 to 64 do
        knotHashRound st

    // XOR groups of 16 and convert to hex string
    Array.chunkBySize 16 st.ary
    |> Array.map (Array.fold (^^^) 0 >> sprintf "%02x")
    |> String.concat ""

[<Fact>]
let testExamples () =
    let st = newState 5 [|3; 4; 1; 5;|]
    knotHashRound st
    Assert.Equal<int>([|3; 4; 2; 1; 0;|], st.ary)

    Assert.Equal("a2582a3a0e66e6e86e3812dcb672a272", knotHash "")
    Assert.Equal("33efeb34ea91902bb2f59c9920caa6cd", knotHash "AoC 2017")
    Assert.Equal("3efbe78a8d82f29979031a4aa0b16a9d", knotHash "1,2,3")
    Assert.Equal("63960835bcdc130f0b66d7ff4f6a5a8e", knotHash "1,2,4")

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day10.txt").Trim()
    let lengths = puzzleInput.Split(',') |> Array.map int
    let st = newState 256 lengths
    knotHashRound st
    Assert.Equal(23874, st.ary[0] * st.ary[1])
    Assert.Equal("e1a65bfb5a5ce396025fab5528c25a87", knotHash puzzleInput)