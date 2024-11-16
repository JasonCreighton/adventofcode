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

let numGroups adjMap =
    let mutable toVisit = Map.keys adjMap |> Set.ofSeq
    let mutable groupsFound = 0
    let rec go progId =
        if Set.contains progId toVisit then
            toVisit <- Set.remove progId toVisit
            Map.find progId adjMap |> Set.iter go

    while not <| Set.isEmpty toVisit do
        groupsFound <- groupsFound + 1
        // Min is not important, just needs to be some arbitrary element
        let startProgId = Set.minElement toVisit
        go startProgId

    groupsFound

let run puzzleInput =
    let adjMap = parsePipes puzzleInput
    (groupSize adjMap 0, numGroups adjMap)

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
    Assert.Equal(2, numGroups adjMap)

[<Fact>]
let testPuzzleInput () = Util.testDay 12 run