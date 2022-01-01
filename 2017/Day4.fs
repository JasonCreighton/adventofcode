module Day4

open Xunit

let noDuplicates keyFunc (passphrase : string) =
    passphrase.Split(' ')
    |> Seq.countBy keyFunc
    |> Seq.exists (fun (_, count) -> count <> 1)
    |> not

let noDuplicateWords = noDuplicates id
let noAnagrams = noDuplicates (fun s -> Seq.toArray s |> Array.sort)

[<Fact>]
let testExamples () =
    Assert.True(noDuplicateWords "aa bb cc dd ee")
    Assert.False(noDuplicateWords "aa bb cc dd aa")
    Assert.True(noDuplicateWords "aa bb cc dd aaa")

[<Fact>]
let testPuzzleInput () =
    let passphrases = System.IO.File.ReadLines("../../../inputs/day4.txt") |> Seq.toArray
    let part1Answer = Seq.filter noDuplicateWords passphrases |> Seq.length
    let part2Answer = Seq.filter noAnagrams passphrases |> Seq.length
    Assert.Equal(451, part1Answer)
    Assert.Equal(223, part2Answer)