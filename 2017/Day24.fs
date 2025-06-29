module Day24

open Xunit

(*
I first converted the puzzle into GraphViz format to view the structure:

graph G {
    v32 -- v31
    v2 -- v2
    v0 -- v43
    v45 -- v15
    v33 -- v24
    v20 -- v20
    v14 -- v42
    v2 -- v35
    v50 -- v27
    v2 -- v17
    v5 -- v45
    v3 -- v14
    v26 -- v1
    v33 -- v38
    v29 -- v6
    v50 -- v32
    v9 -- v48
    v36 -- v34
    v33 -- v50
    v37 -- v35
    v12 -- v12
    v26 -- v13
    v19 -- v4
    v5 -- v5
    v14 -- v46
    v17 -- v29
    v45 -- v43
    v5 -- v0
    v18 -- v18
    v41 -- v22
    v50 -- v3
    v4 -- v4
    v17 -- v1
    v40 -- v7
    v19 -- v0
    v33 -- v7
    v22 -- v48
    v9 -- v14
    v50 -- v43
    v26 -- v29
    v19 -- v33
    v46 -- v31
    v3 -- v16
    v29 -- v46
    v16 -- v0
    v34 -- v17
    v31 -- v7
    v5 -- v27
    v7 -- v4
    v49 -- v49
    v14 -- v21
    v50 -- v9
    v14 -- v44
    v29 -- v29
    v13 -- v38
    v31 -- v11

    v0 [shape=Mdiamond]
}

You can view this online with a viewer like: https://dreampuf.github.io/GraphvizOnline/

Eyeballing the graph, I feel like I can probably brute force it, and also I don't see any obvious way to do better.

*)

type Bridge = {
    length : int
    strength : int
}

let part1Criterion b = (b.strength, 0)
let part2Criterion b = (b.length, b.strength)

let rec bestBridge (criterion : Bridge -> (int * int)) (startFrom : int) (components : (int * int) array) : Bridge =
    let compat = Array.filter (fun (l, r) -> l = startFrom || r = startFrom) components
    if Array.length compat = 0 then
        // Base case: No options left to choose
        { length = 0; strength = 0}
    else
        // Recursive case: The max of all possible options
        Array.maxBy criterion <| Array.map (fun (l, r) ->
            let componentsWithoutSelected = Array.filter (fun c -> c <> (l, r)) components
            let newStartFrom = if l = startFrom then r else l
            let best = bestBridge criterion newStartFrom componentsWithoutSelected
            {
                length = 1 + best.length
                strength = (l + r) + best.strength
            }
        ) compat

let bridgeStrength criterion startFrom components =
    let b = bestBridge criterion startFrom components
    b.strength

let parseComponent (line : string) : (int * int) =
    let c = line.Split("/") |> Array.map int
    (c[0], c[1])

let parseComponents (puzzleInput : string) =
    Util.splitIntoLines puzzleInput |> Array.map parseComponent

let run puzzleInput =
    let parsed = parseComponents puzzleInput
    (bridgeStrength part1Criterion 0 parsed, bridgeStrength part2Criterion 0 parsed)

[<Fact>]
let testExamples () =
    let example1 = """
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
"""
    
    let strongest = bridgeStrength part1Criterion 0 (parseComponents example1)

    Assert.Equal(31, strongest)

    let strengthOfLongest = bridgeStrength part2Criterion 0 (parseComponents example1)

    Assert.Equal(19, strengthOfLongest)

[<Fact>]
let testPuzzleInput () = Util.testDay 24 run