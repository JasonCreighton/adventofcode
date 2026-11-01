u ← •Import "util.bqn"
Parse ← {9↑/⁼∧u.ToNum 𝕩}
ex ← Parse "3,4,3,1,2"

Step ← { 𝕊 hist:
    sp ← 0⊑hist
    ⟨0,0,0,0,0,0,sp,0,0⟩+sp«hist
}

Part1 ← +´Step⍟80
Part2 ← +´Step⍟256

! 5934=Part1 ex
! 26984457539=Part2 ex

parse‿part1‿part2 u.RunDay 6