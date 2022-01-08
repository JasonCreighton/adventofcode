module Day9

open Xunit

type Item =
    | Garbage of int
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

let rec garbageCount ctx acc =
    match getc ctx with
    | '>' -> acc
    | '!' ->
        getc ctx |> ignore
        garbageCount ctx acc
    | _ -> garbageCount ctx (acc + 1)
    
let rec garbage ctx =
    expect ctx '<'
    Garbage (garbageCount ctx 0)

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
    | Garbage _ -> 0
    | Group items -> depth + List.sumBy (score (depth + 1)) items

let scoreString = parse >> score 1

let rec totalGarbage itm =
    match itm with
    | Garbage n -> n
    | Group items -> List.sumBy totalGarbage items

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
    let parsed = parse puzzleInput
    Assert.Equal(12803, score 1 parsed)
    Assert.Equal(6425, totalGarbage parsed)