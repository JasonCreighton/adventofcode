module Day22

open Xunit

type State = {
    nodes : Map<(int * int), bool>
    loc : int * int
    dir : int * int
    numInfectingBursts: int
}

let step st =
    let curInfected = Map.tryFind st.loc st.nodes |> Option.defaultValue false
    let newInfected = not curInfected
    let newDir = if curInfected then (-snd st.dir, fst st.dir) else (snd st.dir, -fst st.dir)
    {
        nodes = Map.add st.loc newInfected st.nodes
        loc = (fst st.loc + fst newDir, snd st.loc + snd newDir)
        dir = newDir
        numInfectingBursts = st.numInfectingBursts + (if newInfected then 1 else 0)
    }

let stepSeq st = Seq.unfold (fun st -> Some(st, step st)) st

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
        |> Array.mapi (fun x ch -> ((x, y), ch = '#'))
    )
    |> Array.concat
    |> Map.ofArray

let run puzzleInput =
    let state = parseMap puzzleInput |> initState
    ((Seq.item 10000 (stepSeq state)).numInfectingBursts, "TODO")

[<Fact>]
let testExamples () =
    let example1 = """
..#
#..
...
"""
    let exampleMap = parseMap example1
    let states = Seq.take 10001 (stepSeq (initState exampleMap)) |> Array.ofSeq

    Assert.Equal(5, states[7].numInfectingBursts)
    Assert.Equal(5587, states[10000].numInfectingBursts)

[<Fact>]
let testPuzzleInput () = Util.testDay 22 run