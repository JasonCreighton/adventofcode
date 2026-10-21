u ← •Import "util.bqn"
Parse ← {'0'-˜((𝕩∊u.digits) u.ExtractRect 𝕩)}

ex ← Parse "
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"
UpperBound ← {9×+´≢𝕩}
Init ← { 𝕊 map: 0⌾(0‿0⊸⊑) (≢map)⥊(UpperBound map)}
Step ← { map 𝕊 best: best
    cols ← 1⊑≢map
    inf ← UpperBound map
    infs ← cols⥊inf
    minNeigh ← (infs«best)⌊(infs»best)⌊(inf«˘best)⌊(inf»˘best)
    best⌊map+minNeigh
}

Part1 ← { 𝕊 map:
    ¯1‿¯1⊑{map Step 𝕩} u._fix (Init map)
}
ExpandMap ← { 𝕊 map:
    a ← +⌜˜↕5
    b ← 9⊸|⌾(-⟜1) a+⌜map
    shape ← ≢b
    dim ← (0⊑shape) × (2⊑shape)
    # The desired memory order of the transposed array, from trailing to leading:
    #
    # 4. Columns of the tile (axis 3)
    # 3. Columns of the 5x5  (axis 1)
    # 2. Rows of the tile    (axis 2)
    # 1. Rows of the 5x5     (axis 0)
    #
    # Then the left argument to ⍉⁼ is given by the axes from the rank-4 array
    # given in the right column above, from leading to trailing. (bottom to top)
    c ← dim‿dim⥊0‿2‿1‿3⍉⁼b
    c
}
Part2 ← Part1 ExpandMap

! 40=Part1 ex
! 315=Part2 ex

parse‿part1‿part2 u.RunDay 15