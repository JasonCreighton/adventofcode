u ← •Import "util.bqn"
Parse ← {/⁼∧u.ToNat 𝕩}
ex ← Parse "16,1,2,0,4,2,7,1,2,14"

# We can regard the cost of moving to the right of a crab as the N-fold
# running sum of an impulse. 2-fold (Part 1) yields a ramp for the cost,
# 3-fold (part 2) yields a quadratic.
LTRCost ← {+`⍟𝕨»𝕩}
MinCost ← {
    costLeft ← 𝕨 LTRCost 𝕩
    costRight ← ⌽𝕨 LTRCost⌽𝕩
    ⌊´costLeft+costRight
}

Part1 ← 2⊸MinCost
Part2 ← 3⊸MinCost

! 37=Part1 ex
! 168=Part2 ex

parse‿part1‿part2 u.RunDay 7