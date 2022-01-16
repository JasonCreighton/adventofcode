module Day14

open Xunit
open System.Numerics

let squaresUsed (seed : string) =    
    [|0..127|]
    |> Array.sumBy (
        sprintf "%s-%d" seed
        >> Day10.binaryKnotHash
        >> Array.sumBy (uint32 >> BitOperations.PopCount)
    )

[<Fact>]
let testExamples () =
    Assert.Equal(8108, squaresUsed "flqrgnkx")

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = "jzgqcdpd"
    Assert.Equal(8074, squaresUsed puzzleInput)