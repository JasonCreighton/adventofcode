module Day25

open Xunit

type TurningMachine = {
    mutable cursor : int
    mutable state : int
    mutable tape : int8 array
}

type Action = {
    newValue : int8    
    cursorDelta : int
    newState : int
}

type Blueprint = {
    initialState : int
    steps : int
    actions : Action[,]
 }

let initMachine initialState =
    {
        cursor = 0
        state = initialState
        tape = [|0y|]
    }


let step (prog: Action[,]) (machine : TurningMachine) : unit =
    // Run appropriate action for the state and cursor position we are in
    let action = prog[machine.state, int machine.tape[machine.cursor]]
    machine.tape[machine.cursor] <- action.newValue
    machine.cursor <- machine.cursor + action.cursorDelta
    machine.state <- action.newState

    // Tape is semantically infinite, so expand it by 2X if necessary
    let curTapeSize = Array.length machine.tape
    if machine.cursor < 0 then
        machine.tape <- Array.concat [|Array.create curTapeSize 0y; machine.tape|]
        machine.cursor <- machine.cursor + curTapeSize

    if machine.cursor >= curTapeSize then
        machine.tape <- Array.concat [|machine.tape; Array.create curTapeSize 0y|]

let parseState (stateText : string) : int =
    int (stateText[0] - 'A')

let parseAction (lines : string array) (offset : int): Action =
    {
        newValue = lines[offset+1].Trim().Split(" ")[4] |> (fun s -> int8 (s[0] - '0'))
        cursorDelta = if lines[offset+2].Trim().Split(" ")[6] = "left." then -1 else 1
        newState = lines[offset+3].Trim().Split(" ")[4] |> parseState
    }

let parseProgram (program : string) : Blueprint =
    let lines = Util.splitIntoLines (program.Trim())
    let initialState = parseState (lines[0].Split(" ")[3])
    let steps = lines[1].Split(" ")[5] |> int
    // Note that Util.splitIntoLines has removed empty lines
    let numStates = (Array.length lines - 2) / 9
    let actions = Array2D.create numStates 2 ({newValue = 0y; cursorDelta = 0; newState = 0})
    for i = 0 to numStates - 1 do
        actions[i, 0] <- parseAction lines (2 + (i * 9) + 1)
        actions[i, 1] <- parseAction lines (2 + (i * 9) + 5)

    {
        initialState = initialState
        steps = steps
        actions = actions
    }

let runBlueprint blueprint =
    let machine = initMachine blueprint.initialState
    for i = 1 to blueprint.steps do
        step blueprint.actions machine

    Array.sumBy int machine.tape


let run puzzleInput =
    (runBlueprint (parseProgram puzzleInput), "N/A")

[<Fact>]
let testExamples () =
    let exampleProgram = """
Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
"""

    let blueprint = parseProgram exampleProgram

    Assert.Equal(3, runBlueprint blueprint)
    

[<Fact>]
let testPuzzleInput () = Util.testDay 25 run