module Day7

open Xunit
open System.Text.RegularExpressions
open System.Collections.Generic

type Program = Program of name : string * weight : int * children : list<Program>

let parseInput (input : string) =
    let mutable programs = Map.empty
    let lines = Regex.Split(input.Trim(), @"\r\n|\r|\n")
    for line in lines do
        let m = Regex.Match(line, @"^([a-z]+) \((\d+)\)( -> ([a-z, ]+))?$")
        let name = m.Groups[1].Value
        let weight = int m.Groups[2].Value
        let childPrograms = if m.Groups[4].Value <> "" then Regex.Split(m.Groups[4].Value, @"[, ]+") else [||]
        programs <- Map.add name (weight, childPrograms) programs

    let allPrograms = Map.keys programs |> Set.ofSeq
    let heldPrograms = Map.fold (fun s _ (w, children) -> Set.union s (Set.ofArray children)) Set.empty programs
    let bottomProgram = Set.difference allPrograms heldPrograms |> Seq.exactlyOne

    let rec buildProgram name =
        let (weight, childNames) = Map.find name programs
        let children = Seq.map buildProgram childNames |> Seq.toList
        Program (name, weight, children)

    buildProgram bottomProgram

[<Fact>]
let testExamples () =
    let exampleInput = "\
        pbga (66)\n\
        xhth (57)\n\
        ebii (61)\n\
        havc (66)\n\
        ktlj (57)\n\
        fwft (72) -> ktlj, cntj, xhth\n\
        qoyq (66)\n\
        padx (45) -> pbga, havc, qoyq\n\
        tknk (41) -> ugml, padx, fwft\n\
        jptl (61)\n\
        ugml (68) -> gyxo, ebii, jptl\n\
        gyxo (61)\n\
        cntj (57)\n\
"
    let (Program (bottomProgram, _, _)) = parseInput exampleInput
    Assert.Equal("tknk", bottomProgram)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day7.txt")
    let (Program (bottomProgram, _, _)) = parseInput puzzleInput
    Assert.Equal("fbgguv", bottomProgram)