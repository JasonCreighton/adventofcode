module Day18

open Xunit

// Want to detect integer overflow, since the problem statement does not give an integer size
open Checked

type CpuState = {
    mutable pc : int
    mutable lastSound : int64
    mutable terminated : bool
    regs : int64 array
}

type inst = CpuState -> unit

// TODO: Parse register or integer as rvalue
let parseReg (regName : string) : int =
    assert (regName.Length = 1)
    int (regName[0] - 'a')

let parseRValue (rvalue : string) : (CpuState -> int64) =
    if System.Char.IsLetter rvalue[0] then
        let reg = parseReg rvalue
        (fun state -> state.regs[reg])
    else
        let x = int rvalue
        (fun state -> x)

let parseInst (line : string) : inst =
    let parts = line.Split(" ", System.StringSplitOptions.RemoveEmptyEntries)
    match parts[0] with
    | "snd" ->
        let arg = parseRValue parts[1]
        (fun state -> state.lastSound <- arg state)
    | "set" ->
        let targetReg = parseReg parts[1]
        let getArg = parseRValue parts[2]
        (fun state -> state.regs[targetReg] <- getArg state)
    | "add" ->
        let targetReg = parseReg parts[1]
        let getArg = parseRValue parts[2]
        (fun state -> state.regs[targetReg] <- state.regs[targetReg] + getArg state)
    | "mul" ->
        let targetReg = parseReg parts[1]
        let getArg = parseRValue parts[2]
        (fun state -> state.regs[targetReg] <- state.regs[targetReg] * getArg state)
    | "mod" ->
        let targetReg = parseReg parts[1]
        let getArg = parseRValue parts[2]
        (fun state -> state.regs[targetReg] <- state.regs[targetReg] % getArg state)
    | "rcv" ->
        let getArg = parseRValue parts[1]
        (fun state ->
            if getArg state <> 0 then
                state.terminated <- true
        )
    | "jgz" ->
        let getTestVal = parseRValue parts[1]
        let getOffsetVal = parseRValue parts[2]
        (fun state ->
            if getTestVal state > 0 then
                // -1 to account for implicit PC+1 that always occurs
                state.pc <- state.pc + int (getOffsetVal state) - 1
        )
    | _ -> failwith "Unknown operation"

let runProgram (prog : inst array) : int64 =
    let state = {
        pc = 0
        lastSound = 0
        terminated = false
        regs = Array.zeroCreate 26
    }

    while not state.terminated do
        prog[state.pc] state
        state.pc <- state.pc + 1

    state.lastSound

let parseProgram (program : string) : inst array =
    Array.map parseInst (Util.splitIntoLines (program.Trim()))

let run puzzleInput =
    let program = parseProgram puzzleInput

    (runProgram program, "TODO")

[<Fact>]
let testExamples () =
    let exampleProgram = """
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
"""
    Assert.Equal(4L, runProgram <| parseProgram exampleProgram)
    

[<Fact>]
let testPuzzleInput () = Util.testDay 18 run