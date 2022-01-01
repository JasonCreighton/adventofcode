module Day3

open Xunit

// Note: "line" does not include start point (x, y)
let line x y dx dy steps = seq { for i in 1 .. steps -> (x + (dx*i), y + (dy*i)) }

let rec spiralFrom x y dx dy steps = seq {
    yield! line x y dx dy steps
    let x, y, dx, dy = (x + (dx*steps), y + (dy*steps), -dy, dx)
    yield! line x y dx dy steps
    let x, y, dx, dy = (x + (dx*steps), y + (dy*steps), -dy, dx)
    yield! spiralFrom x y dx dy (steps + 1)
}

let coords = seq {
    yield (0, 0)
    yield! spiralFrom 0 0 1 0 1
}

let sumsOfNeighboors = seq {
    let mutable previousTotals = Map.empty
    for (x, y) in coords do
        let mutable thisTotal = if (x, y) = (0, 0) then 1 else 0
        for dx in [-1 .. 1] do
            for dy in [-1 .. 1] do
                thisTotal <- thisTotal + (Map.tryFind (x + dx, y + dy) previousTotals |> Option.defaultValue 0)
        yield thisTotal
        previousTotals <- Map.add (x, y) thisTotal previousTotals
}

let part1 n =
    let x, y = Seq.item (n - 1) coords
    abs x + abs y

[<Fact>]
let testExamples () =
    Assert.Equal(0, part1 1)
    Assert.Equal(3, part1 12)
    Assert.Equal(2, part1 23)
    Assert.Equal(31, part1 1024)

    let expectedSumsOfNeighbors = [|1; 1; 2; 4; 5; 10; 11; 23; 25; 26; 54; 57; 59; 122; 133; 142; 147; 304; 330; 351; 362; 747; 806|]
    let calcSumsOfNeighbors = Seq.take (Array.length expectedSumsOfNeighbors) sumsOfNeighboors |> Seq.toArray
    Assert.Equal<int>(expectedSumsOfNeighbors, calcSumsOfNeighbors)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = 312051
    Assert.Equal(430, part1 puzzleInput)

    let part2Answer = Seq.find (fun n -> n > puzzleInput) sumsOfNeighboors
    Assert.Equal(312453, part2Answer)