module Day11

open Xunit

let minSteps (x1, y1) (x2, y2) =
    // We know we need to take a certain number of steps on the X axis
    let xSteps = abs (x1 - x2)
    // After taking those steps, we have taken enough steps to correct the Y delta along the way, or we may need additional steps
    let extraYSteps = max 0 (((abs (y1 - y2)) - xSteps) / 2)
    xSteps + extraYSteps

let move (x, y) dir =
    match dir with
    | "n"  -> (x    , y + 2)
    | "s"  -> (x    , y - 2)
    | "ne" -> (x + 1, y + 1)
    | "se" -> (x + 1, y - 1)
    | "nw" -> (x - 1, y + 1)
    | "sw" -> (x - 1, y - 1)
    | _    -> failwith "Invalid direction"

let allPositions = Array.scan move (0, 0)
let finalPosition = Array.fold move (0, 0)

let numStepsBack (dirs : string) =
    minSteps (finalPosition (dirs.Split(','))) (0, 0)

let maxStepsBack (dirs : string) =
    dirs.Split(',')
    |> allPositions
    |> Array.map (minSteps (0, 0))
    |> Array.max

[<Fact>]
let testExamples () =
    Assert.Equal(3, numStepsBack "ne,ne,ne")
    Assert.Equal(0, numStepsBack "ne,ne,sw,sw")
    Assert.Equal(2, numStepsBack "ne,ne,s,s")
    Assert.Equal(3, numStepsBack "se,sw,se,sw,sw")

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day11.txt").Trim()
    Assert.Equal(715, numStepsBack puzzleInput)
    Assert.Equal(1512, maxStepsBack puzzleInput)