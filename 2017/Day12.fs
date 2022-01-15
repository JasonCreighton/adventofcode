module Day12

open Xunit

let addAdj adjMap fromKey toKey =
    let toSet = Map.tryFind fromKey adjMap |> Option.defaultValue Set.empty
    Map.add fromKey (Set.add toKey toSet) adjMap

let parsePipes (str : string) =
    let mutable adjMap = Map.empty
    let lines = str.Split(System.Environment.NewLine.ToCharArray(), System.StringSplitOptions.RemoveEmptyEntries)
    for line in lines do
        let parts = line.Split(" <-> ")
        let fromProg = int parts[0]
        let toProgs = Array.map int (parts[1].Split(", "))
        for toProg in toProgs do
            adjMap <- addAdj adjMap fromProg toProg
            adjMap <- addAdj adjMap toProg fromProg

    adjMap

let groupSize adjMap srcProgId =
    let mutable visited = Set.empty
    let rec go progId =
        if not <| Set.contains progId visited then
            visited <- Set.add progId visited
            Map.find progId adjMap |> Set.iter go

    go srcProgId
    Set.count visited

[<Fact>]
let testExamples () =
    let exampleInput : string = "\
        0 <-> 2\n\
        1 <-> 1\n\
        2 <-> 0, 3, 4\n\
        3 <-> 2, 4\n\
        4 <-> 2, 3, 6\n\
        5 <-> 6\n\
        6 <-> 4, 5\n\
    "
    let adjMap = parsePipes exampleInput
    Assert.Equal(6, groupSize adjMap 0)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day12.txt").Trim()
    let adjMap = parsePipes puzzleInput
    Assert.Equal(288, groupSize adjMap 0)