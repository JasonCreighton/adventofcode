module Day18

open Xunit

// Want to detect integer overflow, since the problem statement does not give an integer size
open Checked

type CpuState = {
    mutable pc : int
    mutable stalled : bool
    mutable txCounter : int
    regs : int64 array
    txQueue : System.Collections.Generic.Queue<int64>    
    rxQueue : System.Collections.Generic.Queue<int64>
}

type inst = CpuState -> unit

let initCpu txQueue rxQueue =
    {
        pc = 0
        stalled = false
        txCounter = 0
        regs = Array.zeroCreate 26
        txQueue = txQueue
        rxQueue = rxQueue
    }

let step (prog: inst array) (state : CpuState) : unit =
    prog[state.pc] state
    state.pc <- state.pc + 1
    
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

let parseInst (part2: bool) (line : string) : inst =
    let parts = line.Split(" ", System.StringSplitOptions.RemoveEmptyEntries)
    match parts[0] with
    | "snd" ->
        let arg = parseRValue parts[1]
        (fun state ->
            state.txQueue.Enqueue(arg state)
            state.txCounter <- state.txCounter + 1
        )
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
        if part2 then
            let targetReg = parseReg parts[1]
            (fun state ->
                if state.rxQueue.Count > 0 then
                    state.regs[targetReg] <- state.rxQueue.Dequeue()
                    state.stalled <- false
                else
                    state.stalled <- true
                    state.pc <- state.pc - 1 // compensate for implicit PC+1
            )
        else
            let getArg = parseRValue parts[1]
            (fun state ->
                if getArg state <> 0 then
                    state.stalled <- true
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

    
let parseProgram (part2: bool) (program : string) : inst array =
    Array.map (parseInst part2) (Util.splitIntoLines (program.Trim()))

let runPart1 (program : string) : int64 =
    let prog = parseProgram false program
    let queue = new System.Collections.Generic.Queue<int64>();
    let cpu = initCpu queue queue

    while not cpu.stalled do
        step prog cpu

    let mutable lastSound = 0L
    while cpu.txQueue.Count > 0 do
        lastSound <- cpu.txQueue.Dequeue()

    lastSound

let runPart2 (program : string) : int =
    let prog = parseProgram true program
    let queue0To1 = new System.Collections.Generic.Queue<int64>();
    let queue1To0 = new System.Collections.Generic.Queue<int64>();
    let cpu0 = initCpu queue0To1 queue1To0
    let cpu1 = initCpu queue1To0 queue0To1

    // Set program ID for 2nd CPU
    cpu1.regs[int ('p' - 'a')] <- 1

    while not (cpu0.stalled && cpu1.stalled) do
        step prog cpu0
        step prog cpu1

    cpu1.txCounter
    
let run puzzleInput =
    (runPart1 puzzleInput, runPart2 puzzleInput)

[<Fact>]
let testExamples () =
    let exampleProgramPart1 = """
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

    let exampleProgramPart2 = """
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
"""
    Assert.Equal(4L, runPart1 exampleProgramPart1)
    Assert.Equal(3, runPart2 exampleProgramPart2)
    

[<Fact>]
let testPuzzleInput () = Util.testDay 18 run