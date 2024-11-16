module Day8

open Xunit
open System.Text.RegularExpressions

let parseInput (input : string) = Regex.Split(input.Trim(), @"\r\n|\r|\n")

let updateRegs (regs : Map<string, int>) (inst : string) =
    let lookup reg = Map.tryFind reg regs |> Option.defaultValue 0
    match inst.Split(' ') with
    | [|modReg; op; opArg; _; condReg; condOp; condOpArg;|] ->
        let condFunc =
            match condOp with
            | "<" -> (<)
            | "<=" -> (<=)
            | "==" -> (=)
            | "!=" -> (<>)
            | ">=" -> (>=)
            | ">" -> (>)
            | _ -> failwith "unexpected operator"
        let opFunc =
            match op with
            | "inc" -> (+)
            | "dec" -> (-)
            | _ -> failwith "unexpcetd operator"

        if condFunc (lookup condReg) (int condOpArg) then
            Map.add modReg (opFunc (lookup modReg) (int opArg)) regs
        else
            regs
    | _ -> failwith "unexpected number of elements in instructions"

let runInsts = Array.scan updateRegs (Map.add "a" 0 Map.empty) // Add dummy element so Seq.max below doesn't blow up
let maxAtEnd = Array.last >> Map.values >> Seq.max
let maxDuring = (Array.map (Map.values >> Seq.max)) >> Array.max

let run puzzleInput =
    let results = parseInput puzzleInput |> runInsts
    (maxAtEnd results, maxDuring results)

[<Fact>]
let testExamples () =
    let exampleInput : string = "\
        b inc 5 if a > 1\n\
        a inc 1 if b < 5\n\
        c dec -10 if a >= 1\n\
        c inc -20 if c == 10\n\
    "
    let insts = parseInput exampleInput
    let results = runInsts insts
    Assert.Equal(1, maxAtEnd results)
    Assert.Equal(10, maxDuring results)

[<Fact>]
let testPuzzleInput () = Util.testDay 8 run