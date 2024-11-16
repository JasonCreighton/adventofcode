module Day15

open Xunit

let generate (factor : uint32) (seed : uint32) : seq<uint32> =
    seq {
        let mutable state : uint32 = seed
        while true do
            state <- uint32 (((uint64 state) * (uint64 factor)) % 2147483647UL)
            yield state
    }

let generateA = generate 16807ul
let generateB = generate 48271ul
let countMatches = Seq.sumBy (fun (a, b) -> if (a &&& 0xFFFFul) = (b &&& 0xFFFFul) then 1 else 0)

let part1 seedA seedB =
    Seq.zip (generateA seedA) (generateB seedB)
    |> Seq.take 40_000_000
    |> countMatches

let part2 seedA seedB =
    let filteredA = generateA seedA |> Seq.filter (fun x -> x % 4ul = 0ul)
    let filteredB = generateB seedB |> Seq.filter (fun x -> x % 8ul = 0ul)

    Seq.zip filteredA filteredB
    |> Seq.take 5_000_000
    |> countMatches

let run puzzleInput =
    let seeds = Util.splitIntoLines puzzleInput |> Array.map (fun line -> line.Split(" ")[4] |> uint32)
    (part1 seeds[0] seeds[1], part2 seeds[0] seeds[1])

[<Fact>]
let testExamples () =
    Assert.Equal(588, part1 65ul 8921ul)
    Assert.Equal(309, part2 65ul 8921ul)

[<Fact>]
let testPuzzleInput () = Util.testDay 15 run