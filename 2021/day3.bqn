u ← •Import "util.bqn"

Parse ← {'1'=(𝕩∊"01") u.ExtractRect 𝕩}

ex ← Parse u.Trim "
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"

Bin2Dec ← {+´𝕩×⌽2⋆↕≠𝕩}
Part1 ← {
    gamma ← (+˝𝕩)>(≠𝕩)÷2
    epsilon ← ¬gamma
    gamma ×○Bin2Dec epsilon
}

Majority ← {(+´𝕩)≥(≠𝕩)÷2}
Minority ← {(+´𝕩)<(≠𝕩)÷2}
Rating ← {
    # Base case
    1=≠𝕩 ? ⊏𝕩 ;
    # Recursive case
    t ← ⍉𝕩
    hd ← ⊏t
    tl ← ⍉1↓t
    bit ← 𝕎hd
    ftl ← (hd=bit)/tl
    bit ∾ 𝕨 Rating ftl
}
Part2 ← {
    oxy ← majority Rating 𝕩
    co2 ← minority Rating 𝕩
    
    oxy ×○Bin2Dec co2
}

! 198=Part1 ex
! 230=Part2 ex

parse‿part1‿part2 u.RunDay 3