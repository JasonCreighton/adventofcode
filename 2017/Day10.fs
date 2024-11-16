module Day10

open Xunit

type KnotHashState = {
    ary: byte[]
    lengths: byte[]
    mutable i: int
    mutable skipSize: int
}

let newState size lengths = { ary = Array.init size byte; lengths = lengths; i = 0; skipSize = 0 }

let reverseSegment ary startIndex length =
    for i = 0 to (length / 2) - 1 do
        let a = (startIndex + i) % Array.length ary
        let b = (startIndex + length - 1 - i) % Array.length ary
        let tmp = ary[a]
        ary[a] <- ary[b]
        ary[b] <- tmp

let knotHashRound st =
    for length in st.lengths do
        reverseSegment st.ary st.i (int length)
        st.i <- (st.i + (int length) + st.skipSize) % Array.length st.ary
        st.skipSize <- st.skipSize + 1

let binaryKnotHash (str : string) =
    let st = newState 256 (Array.append (Seq.map byte str |> Seq.toArray) [|17uy; 31uy; 73uy; 47uy; 23uy;|])
    for _ = 1 to 64 do
        knotHashRound st

    // XOR groups of 16
    Array.chunkBySize 16 st.ary
    |> Array.map (Array.fold (^^^) 0uy)

let knotHash (str : string) =
    binaryKnotHash str
    |> Array.map (sprintf "%02x")
    |> String.concat ""

let run (puzzleInput : string) =
    let lengths = puzzleInput.Split(',') |> Array.map byte
    let st = newState 256 lengths
    knotHashRound st
    ((int st.ary[0]) * (int st.ary[1]), knotHash puzzleInput)

[<Fact>]
let testExamples () =
    let st = newState 5 [|3uy; 4uy; 1uy; 5uy;|]
    knotHashRound st
    Assert.Equal<byte>([|3uy; 4uy; 2uy; 1uy; 0uy;|], st.ary)

    Assert.Equal("a2582a3a0e66e6e86e3812dcb672a272", knotHash "")
    Assert.Equal("33efeb34ea91902bb2f59c9920caa6cd", knotHash "AoC 2017")
    Assert.Equal("3efbe78a8d82f29979031a4aa0b16a9d", knotHash "1,2,3")
    Assert.Equal("63960835bcdc130f0b66d7ff4f6a5a8e", knotHash "1,2,4")

[<Fact>]
let testPuzzleInput () = Util.testDay 10 run