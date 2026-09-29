module Day22

open Xunit

type Cell =
    | Clean
    | Weakened
    | Infected
    | Flagged

type State = {
    nodes : Cell array2d
    mutable loc : int * int
    mutable dir : int * int
    mutable numInfectingBursts: int
}

let initState map =
    // Assume odd-length, sqaure map. The largest 0-based index will be even, and we can just divide by 2 to find the middle
    let biggestIndex = Map.maxKeyValue map |> fst |> fst
    let middle = biggestIndex / 2

    // Use a 1000x1000 array to store the cells, which is big enough for my input
    let aryLen = 1000
    let offset = aryLen / 2
    let ary = Array2D.create aryLen aryLen Clean
    Map.iter (fun (x, y) cell -> ary[offset + x, offset + y] <- cell) map
    {
        nodes = ary
        loc = (offset + middle, offset + middle)
        dir = (0, -1)
        numInfectingBursts = 0
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
    let (x, y) = st.loc
    let curCell = st.nodes[x, y]
    let newCell = nextCell curCell
    let newDir = nextDir curCell st.dir
    let (dx, dy) = newDir
    st.nodes[x, y] <- newCell
    st.loc <- (x + dx, y + dy)
    st.dir <- newDir
    st.numInfectingBursts <- st.numInfectingBursts + (if newCell = Infected then 1 else 0)

let stepN n nextCell map =
    let st = initState map
    for i in 1..n do
        step nextCell st
    st

let parseMap puzzleInput =
    Util.splitIntoLines puzzleInput
    |> Array.mapi (fun y line ->
        Seq.toArray line
        |> Array.mapi (fun x ch -> ((x, y), if ch = '#' then Infected else Clean))
    )
    |> Array.concat
    |> Map.ofArray

let run puzzleInput =
    let map = parseMap puzzleInput
    ((stepN 10000 part1 map).numInfectingBursts, (stepN 10000000 part2 map).numInfectingBursts)

[<Fact>]
let testExamples () =
    let example1 = """
..#
#..
...
"""
    let exampleMap = parseMap example1

    Assert.Equal(5, (stepN 7 part1 exampleMap).numInfectingBursts)
    Assert.Equal(5587, (stepN 10000 part1 exampleMap).numInfectingBursts)
    Assert.Equal(26, (stepN 100 part2 exampleMap).numInfectingBursts)
    Assert.Equal(2511944, (stepN 10000000 part2 exampleMap).numInfectingBursts)

[<Fact>]
let testPuzzleInput () = Util.testDay 22 run