module Day14

open Xunit
open System.Numerics

let usedGrid seed =
    let grid = Array2D.create 128 128 false
    for y in 0 .. 127 do
        let row = sprintf "%s-%d" seed y |> Day10.binaryKnotHash
        for byteIndex in 0 .. 15 do
            for bitIndex in 0 .. 7 do
                let x = (byteIndex * 8) + bitIndex
                grid[x, y] <- ((row[byteIndex] >>> (7-bitIndex)) &&& 1uy) <> 0uy

    grid

let squaresUsed (seed : string) : int =
    usedGrid seed
    |> Seq.cast<bool>
    |> Seq.sumBy (fun used -> if used then 1 else 0)

let rec fillContiguous (used : bool[,]) (seen : bool[,]) (x : int) (y : int) =
    if x >= used.GetLowerBound(0) && x <= used.GetUpperBound(0) && y >= used.GetLowerBound(1) && y <= used.GetUpperBound(1) then
        if used[x, y] && not seen[x, y] then
            seen[x, y] <- true
            fillContiguous used seen (x + 0) (y + 1)
            fillContiguous used seen (x + 0) (y - 1)
            fillContiguous used seen (x + 1) (y + 0)
            fillContiguous used seen (x - 1) (y + 0)
        

let regionsPresent (seed : string) : int =
    let mutable numRegions = 0
    let used = usedGrid seed
    let seen = Array2D.create 128 128 false

    for y in 0 .. 127 do
        for x in 0 .. 127 do
            if used[x, y] && not seen[x, y] then
                fillContiguous used seen x y
                numRegions <- numRegions + 1

    numRegions

let run puzzleInput =
    (squaresUsed puzzleInput, regionsPresent puzzleInput)

[<Fact>]
let testExamples () =
    let exampleInput = "flqrgnkx"
    Assert.Equal(8108, squaresUsed exampleInput)
    Assert.Equal(1242, regionsPresent exampleInput)

[<Fact>]
let testPuzzleInput () = Util.testDay 14 run