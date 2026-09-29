module Day21

open Xunit
open System.Collections.Generic

let flip pat =
    Array2D.init (Array2D.length1 pat) (Array2D.length2 pat) (fun y x ->
        pat[y, -x + Array2D.length2 pat - 1]
    )

let rotate pat =
    Array2D.init (Array2D.length2 pat) (Array2D.length1 pat) (fun y x ->
        pat[-x + Array2D.length2 pat - 1, y]
    )

let allFlipsAndRotations pat =
    let rot0 = pat
    let rot1 = rotate rot0
    let rot2 = rotate rot1
    let rot3 = rotate rot2
    let rotations = [|rot0; rot1; rot2; rot3|]
    let flippedRotations = Array.map flip rotations
    Array.concat [|rotations; flippedRotations|]

// Alternate dictionary key to use for 2D array of bools for lookup efficiency
let ruleKey ary =
    let len = Array2D.length1 ary
    let mutable key = len
    for x = 0 to len-1 do
        for y = 0 to len-1 do
            key <- (key <<< 1) ||| (if ary[x,y] then 1 else 0)
    key

let flatToGrouped groupSize flat =
    let numGroups = Array2D.length1 flat / groupSize
    Array2D.init numGroups numGroups (fun gy gx ->
        Array2D.init groupSize groupSize (fun y x ->
            flat[gy*groupSize + y, gx*groupSize + x]
        )
    )

let groupedToFlat (grouped: 'a array2d array2d) =
    let groupSize = Array2D.length1 (grouped[0, 0])
    let numGroups = Array2D.length1 grouped
    let flatLen = groupSize*numGroups
    Array2D.init flatLen flatLen (fun y x ->
        let grp = grouped[y / groupSize, x / groupSize]
        grp[y % groupSize, x % groupSize]
    )

let step (rules : IReadOnlyDictionary<int, bool array2d>) flat =
    let groupSize = if ((Array2D.length1 flat) % 2) = 0 then 2 else 3
    flatToGrouped groupSize flat
    |> Array2D.map (fun grp -> rules[ruleKey grp])
    |> groupedToFlat

let stepSeq flat rules =
    Seq.unfold (fun st -> Some(st, step rules st)) flat

let printGrid flat =
    for y in 0 .. Array2D.length2 flat - 1 do
        for x in 0 .. Array2D.length1 flat - 1 do
            printf "%c" (if flat[y, x] then '#' else '.')
        printf "\n"

let initialGrid = array2D [| [| false; true; false|]; [| false; false; true|]; [|true; true; true|]|]

let numPixelsOn flat =
    // No "fold" operation on Array2D, it seems
    let mutable sum = 0
    Array2D.iter (fun on -> sum <- sum + (if on then 1 else 0)) flat
    sum

let numPixelsOnAfter flat rules steps =
    stepSeq flat rules
    |> Seq.item steps 
    |> numPixelsOn

let parsePattern (pat : string) =
    pat.Split("/")
    |> Array.map (fun chunk ->
        Seq.toArray chunk
        |> Array.map (fun ch -> ch = '#')
    )
    |> array2D

let parseRule (line : string) =
    let ary = line.Split(" => ")
    let lhs = parsePattern ary[0]
    let rhs = parsePattern ary[1]
    Array.map (fun p -> (ruleKey p, rhs)) (allFlipsAndRotations lhs)

let parseRules (puzzleInput : string) =
    Util.splitIntoLines puzzleInput
    |> Array.map parseRule
    |> Array.concat
    |> readOnlyDict

let run puzzleInput =
    let rules = parseRules puzzleInput
    (numPixelsOnAfter initialGrid rules 5, numPixelsOnAfter initialGrid rules 18)

[<Fact>]
let testExamples () =
    let example1 = """
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
"""
    let exampleRules = parseRules example1
    let grid =
        step exampleRules initialGrid
        |> step exampleRules   

    Assert.Equal(12, numPixelsOn grid)

[<Fact>]
let testPuzzleInput () = Util.testDay 21 run