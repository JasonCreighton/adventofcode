module Day23

open Xunit

// Want to detect integer overflow, since the problem statement does not give an integer size
open Checked

type CpuState = {
    mutable pc : int
    mutable mulCounter : int
    regs : int64 array
}

type inst = CpuState -> unit

let initCpu () =
    {
        pc = 0
        mulCounter = 0
        regs = Array.zeroCreate 8
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
    | "set" ->
        let targetReg = parseReg parts[1]
        let getArg = parseRValue parts[2]
        (fun state -> state.regs[targetReg] <- getArg state)
    | "sub" ->
        let targetReg = parseReg parts[1]
        let getArg = parseRValue parts[2]
        (fun state -> state.regs[targetReg] <- state.regs[targetReg] - getArg state)
    | "mul" ->
        let targetReg = parseReg parts[1]
        let getArg = parseRValue parts[2]
        (fun state ->
            state.mulCounter <- state.mulCounter + 1
            state.regs[targetReg] <- state.regs[targetReg] * getArg state
        )
    | "jnz" ->
        let getTestVal = parseRValue parts[1]
        let getOffsetVal = parseRValue parts[2]
        (fun state ->
            if getTestVal state <> 0 then
                // -1 to account for implicit PC+1 that always occurs
                state.pc <- state.pc + int (getOffsetVal state) - 1
        )
    | _ -> failwith "Unknown operation"

let parseProgram (part2: bool) (program : string) : inst array =
    Array.map (parseInst part2) (Util.splitIntoLines (program.Trim()))

let primalityTable (upTo: int) : bool array =
    let isPrime = Array.create (upTo + 1) true
    isPrime[0] <- false
    isPrime[1] <- false

    let mutable curPrime = 0

    while curPrime < Array.length isPrime do
        while curPrime < Array.length isPrime && not isPrime[curPrime] do
            curPrime <- curPrime + 1

        let mutable composite = curPrime * 2
        while composite < Array.length isPrime do
            isPrime[composite] <- false
            composite <- composite + curPrime

        curPrime <- curPrime + 1

    isPrime

let runPart1 (program : string) : int64 =
    let prog = parseProgram false program
    let cpu = initCpu ()

    while cpu.pc >= 0 && cpu.pc < Array.length prog do
        step prog cpu

    cpu.mulCounter

// Sadly I have hard-coded some numbers from manual inspection of the program
// It is counting the number of composite numbers in some range with some stride
let runPart2 () : int =
    let lowerBound = 106700
    let upperBound = 123700
    let inc = 17

    let isPrime = primalityTable upperBound
    
    {lowerBound .. inc .. upperBound}    
    |> Seq.filter (fun n -> not isPrime[n])
    |> Seq.length

let run puzzleInput =
    (runPart1 puzzleInput, runPart2 ())

[<Fact>]
let testPrimalityTable () =
    let isPrime = primalityTable 10

    Assert.Equal<bool>([|false; false; true; true; false; true; false; true; false; false; false|], isPrime)

[<Fact>]
let testPuzzleInput () = Util.testDay 23 run