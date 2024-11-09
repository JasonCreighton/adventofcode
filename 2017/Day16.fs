module Day16

open Xunit

let spin (dist : int) (dancers : array<char>) : array<char> =
    let len = Array.length dancers
    Array.init len (fun i -> dancers[(i - dist + len) % len])

let exchange (a : int) (b : int) (dancers : array<char>) : array<char> =
    let ary = Array.copy dancers

    let tmp = ary[a]
    ary[a] <- ary[b]
    ary[b] <- tmp

    ary

let partner (dancerA : char) (dancerB : char) (dancers : array<char>) : array<char> =
    let idxA = Array.findIndex (fun d -> d = dancerA) dancers
    let idxB = Array.findIndex (fun d -> d = dancerB) dancers
    exchange idxA idxB dancers


let textCommand (dancers: array<char>) (cmd : string) : array<char> =
    match cmd[0] with
    | 's' -> spin (int cmd[1..]) dancers
    | 'x' ->
        let [|a; b|] = Array.map int (cmd[1..].Split("/"))
        exchange a b dancers
    | 'p' ->
        let [|dancerA; dancerB|] = Array.map (fun (s : string) -> s[0]) (cmd[1..].Split("/"))
        partner dancerA dancerB dancers

[<Fact>]
let testExamples () =
    let state0 = [|'a' .. 'e'|]

    let state1 = textCommand state0 "s1" 
    Assert.Equal<char>([|'e'; 'a'; 'b'; 'c'; 'd'|], state1)

    let state2 = textCommand state1 "x3/4" 
    Assert.Equal<char>([|'e'; 'a'; 'b'; 'd'; 'c'|], state2)

    let state3 = textCommand state2 "pe/b" 
    Assert.Equal<char>([|'b'; 'a'; 'e'; 'd'; 'c'|], state3)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day16.txt").Trim()
    let commands = puzzleInput.Split(",")
    let initial = [|'a' .. 'p'|];    
    let final = Array.fold textCommand initial commands
    let part1_answer = System.String final
    Assert.Equal("kpbodeajhlicngmf", part1_answer)
