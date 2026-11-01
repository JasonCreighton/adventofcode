u ← •Import "util.bqn"
Parse ← {
    map ← (¬𝕩∊u.ws) u.ExtractRect 𝕩
    ⟨map='>',map='v'⟩
}

ex ← Parse u.Trim "
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
"

StepEast ← { 𝕊 east‿south:
    empty ← (¬east)∧(¬south)
    moveFrom ← east∧1⌽˘empty
    moveTo ← ¯1⌽˘moveFrom
    ⟨moveTo∨east∧¬moveFrom, south⟩
}

StepSouth ← { 𝕊 east‿south:
    empty ← (¬east)∧(¬south)
    moveFrom ← south∧1⌽empty
    moveTo ← ¯1⌽moveFrom
    ⟨east, moveTo∨south∧¬moveFrom⟩
}

Step ← StepSouth StepEast

Part1 ← {
    n ← 0
    {n +↩ 1 ⋄ Step 𝕩} u._fix 𝕩
    n
}
Part2 ← { 𝕩 ⋄ "N/A" }

! 58=Part1 ex

parse‿part1‿part2 u.RunDay 25