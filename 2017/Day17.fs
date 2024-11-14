module Day17

open Xunit

type CircularBuffer = { ary: int array; position: int }

let initial = { position = 0; ary = [|0|] }

// Insert one element into the circular buffer, returning a new buffer
let insert (steps: int) (buf : CircularBuffer) : CircularBuffer =
    let aryLen = Array.length buf.ary
    let newPos = ((buf.position + steps) % aryLen) + 1
    let insertVal = aryLen
    {
        position = newPos;
        ary = Array.insertAt newPos insertVal buf.ary
    }

// Repeatedly insert elements into the circular buffer, returning the final buffer
let rec insertUpTo (steps: int) (n : int) (buf: CircularBuffer) : CircularBuffer =
    if n < Array.length buf.ary then
        buf
    else
        insertUpTo steps n (insert steps buf)

// Returns the circular buffer after inserting a series of values up to "n".
let buffer (steps : int) (n : int) : int array =
    (insertUpTo steps n initial).ary

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

// Helper function for tests
let valueAfter (buf : int array) (value : int) =
    buf[((Array.findIndex (fun x -> x = value) buf) + 1) % Array.length buf]

[<Fact>]
let testNumberAfterZero () =
    let steps = 3
    for n in {2 .. 100} do
        let buf = buffer steps n
        let expectedAfterZero = valueAfter buf 0
        let actualAfterZero = numberAfterZero steps n
        Assert.Equal(expectedAfterZero, actualAfterZero)

[<Fact>]
let testExamples () =
    Assert.Equal<int>([|0|], buffer 3 0)
    Assert.Equal<int>([|0; 1|], buffer 3 1)
    Assert.Equal<int>([|0; 2; 1|], buffer 3 2)
    Assert.Equal<int>([|0; 2; 3; 1|], buffer 3 3)
    Assert.Equal<int>([|0; 2; 4; 3; 1|], buffer 3 4)
    Assert.Equal<int>([|0; 5; 2; 4; 3; 1|], buffer 3 5)
    Assert.Equal<int>([|0; 5; 2; 4; 3; 6; 1|], buffer 3 6)
    Assert.Equal<int>([|0; 5; 7; 2; 4; 3; 6; 1|], buffer 3 7)
    Assert.Equal<int>([|0; 5; 7; 2; 4; 3; 8; 6; 1|], buffer 3 8)
    Assert.Equal<int>([|0; 9; 5; 7; 2; 4; 3; 8; 6; 1|], buffer 3 9)

[<Fact>]
let testPuzzleInput () =
    let puzzleInput = 369
    let puzzleResult = buffer puzzleInput 2017
    Assert.Equal(1547, valueAfter puzzleResult 2017)

    let part2Answer = numberAfterZero puzzleInput 50_000_000
    Assert.Equal(31154878, part2Answer)