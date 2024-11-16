module Day6

open Xunit

let puzzleInput = [|4; 10; 4; 1; 8; 4; 9; 14; 5; 1; 14; 15; 0; 15; 3; 5;|]

let reallocate (ary : int[]) =
    let (bankIdx, _) = Seq.indexed ary |> Seq.maxBy (fun (i, blocks) -> (blocks, -i))
    let bankAmount = ary[bankIdx]
    ary[bankIdx] <- 0
    for i = 1 to bankAmount do
        let j = ((bankIdx) + i) % ary.Length
        ary[j] <- ary[j] + 1

let numSteps initial =
    let mutable seen = Map.empty
    let mutable ary = initial
    let mutable finished = false

    while not finished do
        let asList = Array.toList ary
        if not (Map.containsKey asList seen) then            
            seen <- Map.add asList seen.Count seen
            reallocate ary
        else
            finished <- true

    (seen.Count, seen.Count - (Map.find (Array.toList ary) seen))

let run (puzzleInput : string)=
    let initial = puzzleInput.Split(" ", System.StringSplitOptions.RemoveEmptyEntries) |> Array.map int
    numSteps initial

[<Fact>]
let testExamples () =
    let initial = [|0; 2; 7; 0;|]
    Assert.Equal((5, 4), numSteps initial)

[<Fact>]
let testPuzzleInput () = Util.testDay 6 run