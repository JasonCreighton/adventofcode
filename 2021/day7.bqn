u ← •Import "util.bqn"
Parse ← {/⁼∧u.ToNat 𝕩}
ex ← Parse "16,1,2,0,4,2,7,1,2,14"

Part1 ← {
    costLeft ← +`+`»𝕩
    costRight ← ⌽+`+`»⌽𝕩
    ⌊´costLeft+costRight
}
Part2 ← {𝕩 ⋄ "TODO"}

! 37=Part1 ex

parse‿part1‿part2 u.RunDay 7