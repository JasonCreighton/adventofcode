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

let parseCommand (cmd : string) : (array<char> -> array<char>) =
    match cmd[0] with
    | 's' -> spin (int cmd[1..])
    | 'x' ->
        let [|a; b|] = Array.map int (cmd[1..].Split("/"))
        exchange a b
    | 'p' ->
        let [|dancerA; dancerB|] = Array.map (fun (s : string) -> s[0]) (cmd[1..].Split("/"))
        partner dancerA dancerB

let dance (commands : array<array<char> -> array<char>>) (state : array<char>) : array<char> =
    Array.fold (|>) state commands

let findCycle commands initial =
    // Infinite list of the results of all dances
    let danceResults = Seq.unfold (fun s -> Some (s, dance commands s)) (dance commands initial)

    // We hope that we return to the initial state at some point, otherwise it would be
    // too hard to calculate a billion dances.
    let cycle = Seq.takeWhile (fun s -> s <> initial) danceResults

    // Stick the initial state at the beginning to make the indexing work out nicer.
    Array.ofSeq (Seq.append (Seq.singleton initial) cycle)

let part2 commands initial =
    let cycle = findCycle commands initial
    cycle[1000000000 % Array.length cycle]

[<Fact>]
let testExamples () =
    let state0 = [|'a' .. 'e'|]

    let state1 = parseCommand "s1" state0
    Assert.Equal<char>([|'e'; 'a'; 'b'; 'c'; 'd'|], state1)

    let state2 = parseCommand "x3/4" state1
    Assert.Equal<char>([|'e'; 'a'; 'b'; 'd'; 'c'|], state2)

    let state3 = parseCommand "pe/b" state2
    Assert.Equal<char>([|'b'; 'a'; 'e'; 'd'; 'c'|], state3)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = System.IO.File.ReadAllText("../../../inputs/day16.txt").Trim()
    let commands = puzzleInput.Split(",") |> Array.map parseCommand
    let initial = [|'a' .. 'p'|];    
    let final = Array.fold (|>) initial commands
    let part1_answer = System.String final
    Assert.Equal("kpbodeajhlicngmf", part1_answer)

    let part2_answer = part2 commands initial |> System.String
    Assert.Equal("ahgpjdkcbfmneloi", part2_answer)
