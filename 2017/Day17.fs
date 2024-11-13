module Day17

open Xunit

// Returns the circular buffer after inserting the value "n". The inserted value
// is always at index 0 in the returned array.
let rec buffer (steps : int) (n : int) : int array =
    match n with
    | 0 -> [|0|]
    | n ->
        let lastBuf = buffer steps (n - 1)
        let rest = Seq.init (Array.length lastBuf) (fun i -> lastBuf[(i + steps + 1) % Array.length lastBuf])
        Array.ofSeq (Seq.append (Seq.singleton n) rest)

// More lightweight solution for part 2. Still kinda slow, I assume due to the
// loop-carried dependence of the divide.
let numberAfterZero (steps : int) (n : int) : int =
    let mutable position = 0
    let mutable afterZero = 0
    let mutable len = 1

    while len <= n do        
        position <- ((position + steps) % len) + 1

        // We consider index 0 to always contain the value zero, so if we write
        // after that we need to record what we wrote
        if position = 1 then
            afterZero <- len

        len <- len + 1

    afterZero

[<Fact>]
let testNumberAfterZero () =
    let steps = 3
    for n in {2 .. 100} do
        let buf = buffer steps n
        let expectedAfterZero = buf[((Array.findIndex (fun x -> x = 0) buf) + 1) % Array.length buf]
        let actualAfterZero = numberAfterZero steps n
        Assert.Equal(expectedAfterZero, actualAfterZero)

[<Fact>]
let testExamples () =
    Assert.Equal<int>([|0|], buffer 3 0)
    Assert.Equal<int>([|1; 0|], buffer 3 1)
    Assert.Equal<int>([|2; 1; 0|], buffer 3 2)
    Assert.Equal<int>([|3; 1; 0; 2|], buffer 3 3)
    Assert.Equal<int>([|4; 3; 1; 0; 2|], buffer 3 4)
    Assert.Equal<int>([|5; 2; 4; 3; 1; 0|], buffer 3 5)
    Assert.Equal<int>([|6; 1; 0; 5; 2; 4; 3|], buffer 3 6)
    Assert.Equal<int>([|7; 2; 4; 3; 6; 1; 0; 5|], buffer 3 7)
    Assert.Equal<int>([|8; 6; 1; 0; 5; 7; 2; 4; 3|], buffer 3 8)
    Assert.Equal<int>([|9; 5; 7; 2; 4; 3; 8; 6; 1; 0|], buffer 3 9)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = 369
    let puzzleResult = buffer puzzleInput 2017
    Assert.Equal(1547, puzzleResult[1])

    let part2Answer = numberAfterZero puzzleInput 50_000_000
    Assert.Equal(31154878, part2Answer)