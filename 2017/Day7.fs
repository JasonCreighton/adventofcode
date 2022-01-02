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

let rec balanceCorrections prog =
    let (Program (name, weight, children)) = prog
    let childTotalWeights, childCorrections = List.map balanceCorrections children |> List.unzip

    if childTotalWeights = [] then
        // No children, nothing to balance
        (weight, Set.empty)
    else
        let allChildCorrections = List.fold Set.union Set.empty childCorrections

        // Find the most common weight for children
        let mostCommonWeight = childTotalWeights |> List.countBy id |> List.maxBy snd |> fst

        // Find children that do not match
        let childrenNeedingCorrection =
            List.zip children childTotalWeights
            |> List.filter (fun (prog, w) -> w <> mostCommonWeight)

        // Calculate corrections needed to make children match
        let corrections = List.map (fun (prog, w) -> (mostCommonWeight - w, prog)) childrenNeedingCorrection

        let correctionWeight = List.map fst corrections |> List.sum

        // Include correction in reported weight, so imbalances are only corrected for once
        (weight + (List.sum childTotalWeights) + correctionWeight, Set.union allChildCorrections (Set.ofList corrections))


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
    let bottomProgram = parseInput exampleInput
    let (Program (bottomProgramName, _, _)) = bottomProgram
    let (correction, Program (_, uncorrectedWeight, _)) = balanceCorrections bottomProgram |> snd |> Set.toSeq |> Seq.exactlyOne
    Assert.Equal("tknk", bottomProgramName)
    Assert.Equal(60, uncorrectedWeight + correction)

    

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day7.txt")
    let bottomProgram = parseInput puzzleInput
    let (Program (bottomProgramName, _, _)) = bottomProgram
    let (correction, Program (_, uncorrectedWeight, _)) = balanceCorrections bottomProgram |> snd |> Set.toSeq |> Seq.exactlyOne
    Assert.Equal("fbgguv", bottomProgramName)
    Assert.Equal(1864, uncorrectedWeight + correction)