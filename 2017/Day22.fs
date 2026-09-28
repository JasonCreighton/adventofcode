module Day22

open Xunit

type Cell =
    | Clean
    | Weakened
    | Infected
    | Flagged

type State = {
    nodes : Map<(int * int), Cell>
    loc : int * int
    dir : int * int
    numInfectingBursts: int
}

let nextDir curCell (dx, dy) =
    match curCell with
    | Clean    -> ( dy, -dx) // left
    | Weakened -> ( dx,  dy) // same direction
    | Infected -> (-dy,  dx) // right
    | Flagged  -> (-dx, -dy) // reverse

let part1 curCell =
    match curCell with
    | Clean    -> Infected
    | Infected -> Clean
    | _        -> failwith "Shouldn't happen in part1"

let part2 curCell =
    match curCell with
    | Clean    -> Weakened
    | Weakened -> Infected
    | Infected -> Flagged
    | Flagged  -> Clean

let step nextCell st =
    let curCell = Map.tryFind st.loc st.nodes |> Option.defaultValue Clean
    let newCell = nextCell curCell
    let newDir = nextDir curCell st.dir
    {
        nodes = Map.add st.loc newCell st.nodes
        loc = (fst st.loc + fst newDir, snd st.loc + snd newDir)
        dir = newDir
        numInfectingBursts = st.numInfectingBursts + (if newCell = Infected then 1 else 0)
    }

let stepSeq nextCell st = Seq.unfold (fun st -> Some(st, step nextCell st)) st

let stepN n nextCell st = Seq.item n (stepSeq nextCell st)

let initState map =
    // Assume odd-length, sqaure map. The largest 0-based index will be even, and we can just divide by 2 to find the middle
    let biggestIndex = Map.maxKeyValue map |> fst |> fst    
    let middle = biggestIndex / 2
    {
        nodes = map
        loc = (middle, middle)
        dir = (0, -1)
        numInfectingBursts = 0
    }

let parseMap puzzleInput =
    Util.splitIntoLines puzzleInput
    |> Array.mapi (fun y line ->
        Seq.toArray line
        |> Array.mapi (fun x ch -> ((x, y), if ch = '#' then Infected else Clean))
    )
    |> Array.concat
    |> Map.ofArray

let run puzzleInput =
    let state = parseMap puzzleInput |> initState
    ((stepN 10000 part1 state).numInfectingBursts, (stepN 10000000 part2 state).numInfectingBursts)

[<Fact>]
let testExamples () =
    let example1 = """
..#
#..
...
"""
    let exampleMap = parseMap example1
    let exampleState = initState exampleMap

    Assert.Equal(5, (stepN 7 part1 exampleState).numInfectingBursts)
    Assert.Equal(5587, (stepN 10000 part1 exampleState).numInfectingBursts)
    Assert.Equal(26, (stepN 100 part2 exampleState).numInfectingBursts)
    Assert.Equal(2511944, (stepN 10000000 part2 exampleState).numInfectingBursts)

[<Fact>]
let testPuzzleInput () = Util.testDay 22 run