module Day9

open Xunit

type Item =
    | Garbage
    | Group of list<Item>

type ParseContext = {
    input: string
    mutable i: int
}

let peek ctx = ctx.input[ctx.i]

let getc ctx =
    let ch = peek ctx
    ctx.i <- ctx.i + 1
    ch

let expect ctx expected =
    let ch = getc ctx
    assert (ch = expected)

let rec garbageContents ctx =
    match getc ctx with
    | '>' -> Garbage
    | '!' ->
        getc ctx |> ignore
        garbageContents ctx
    | _ -> garbageContents ctx
    
let rec garbage ctx =
    expect ctx '<'
    garbageContents ctx

let rec item ctx =
    match peek ctx with
    | '<' -> garbage ctx
    | '{' -> group ctx
    | _ -> failwith "Unxpected character while parsing item"
and group ctx =
    expect ctx '{'
    let grp = Group (itemList ctx)
    expect ctx '}'
    grp    
and itemList ctx =
    match peek ctx with
    | '<' | '{' ->
        let itm = item ctx
        itm :: itemList ctx
    | ',' ->
        expect ctx ','
        itemList ctx
    | '}' -> []
    | _ -> failwith "Unexpected character while parsing item list"

let parse str =
    let ctx = {i = 0; input = str}
    item ctx

let rec score depth itm =
    match itm with
    | Garbage -> 0
    | Group items -> depth + List.sumBy (score (depth + 1)) items

let scoreString = parse >> score 1

[<Fact>]
let testExamples () =
    Assert.Equal(1, scoreString "{}")
    Assert.Equal(6, scoreString "{{{}}}")
    Assert.Equal(5, scoreString "{{},{}}")
    Assert.Equal(16, scoreString "{{{},{},{{}}}}")
    Assert.Equal(1, scoreString "{<a>,<a>,<a>,<a>}")
    Assert.Equal(9, scoreString "{{<ab>},{<ab>},{<ab>},{<ab>}}")
    Assert.Equal(9, scoreString "{{<!!>},{<!!>},{<!!>},{<!!>}}")
    Assert.Equal(3, scoreString "{{<a!>},{<a!>},{<a!>},{<ab>}}")

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day9.txt")
    Assert.Equal(12803, scoreString puzzleInput)