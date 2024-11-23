module Day20

open Xunit

let manhattanMagnitude (x, y, z) =
    abs x + abs y + abs z

let parseLine (line : string) =
    let p_v_a = line.Split(", ")
    let a_coords = p_v_a[2].Split("=")
    let coordsStr = a_coords[1][1..a_coords[1].Length-2]
    let coords = Array.map int (coordsStr.Split(","))
    (coords[0], coords[1], coords[2])

let closestParticle (puzzleInput : string) =
    Util.splitIntoLines puzzleInput
    |> Array.map (parseLine >> manhattanMagnitude)
    |> Array.indexed
    |> Array.minBy snd
    |> fst

let run puzzleInput =    
    (closestParticle puzzleInput, "TODO")

[<Fact>]
let testExamples () =
    let exampleInput = """
p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
"""
    
    let particleIdx = closestParticle exampleInput

    Assert.Equal(0, particleIdx)

[<Fact>]
let testPuzzleInput () = Util.testDay 20 run