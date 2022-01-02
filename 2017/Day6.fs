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
    let mutable seen = Set.empty
    let mutable ary = initial
    let mutable finished = false

    while not finished do
        let asList = Array.toList ary
        if not (Set.contains asList seen) then            
            seen <- Set.add asList seen
            reallocate ary
        else
            finished <- true

    seen.Count

[<Fact>]
let testExamples () =
    let initial = [|0; 2; 7; 0;|]
    Assert.Equal(5, numSteps initial)

[<Fact>]
let testPuzzleInput () =
    let initial = Array.copy puzzleInput
    Assert.Equal(12841, numSteps initial)