module Day19

open Xunit

let parseInput (puzzleInput : string) : char array * int =
    let rowStride = puzzleInput.IndexOf("\n ") + 1
    let flatCharAry = puzzleInput.ToCharArray()

    (flatCharAry, rowStride)

let findLetters ((map, width) : (char array * int)) : (string * int) =
    let startPos = Array.findIndex (fun x -> x = '|') map[0..width-1]
    let startDirection = width // down
    let rec go (map : char array) width pos dir numSteps foundLetters =
        match map[pos] with
        | '-' | '|' -> go map width (pos + dir) dir (numSteps + 1) foundLetters
        | '+' ->
            // Gotta turn. Find directions excluding where we came from.
            let possibleDirs = [|1; -1; width; -width|] |> Array.filter (fun d ->
                d <> -dir && map[pos + d] <> ' '
            )
            match possibleDirs with
            | [|newDir|] -> go map width (pos + newDir) newDir (numSteps + 1) foundLetters
            | _ -> failwith "Did not expect more than one possible direction to go"
        | letter when System.Char.IsAsciiLetterUpper(letter) ->
            go map width (pos + dir) dir (numSteps + 1) (letter :: foundLetters)
        | ' ' ->
            // All done! Terminate the search
            (System.String.Concat<char> (List.rev foundLetters), numSteps)
        | _ -> failwith "Unexpected character"
        
    go map width startPos startDirection 0 []

let run puzzleInput =
    let parsed = parseInput puzzleInput
    let (letters, steps) = findLetters parsed
    (letters, steps)

[<Fact>]
let testExamples () =
    let exampleInput = """     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 
                
"""
    
    let parsed = parseInput exampleInput
    let (letters, steps) = findLetters parsed

    Assert.Equal("ABCDEF", letters)
    Assert.Equal(38, steps)

[<Fact>]
let testPuzzleInput () = Util.testDay 19 run