u ← •Import "util.bqn"

Parse ← {⍉∘‿4⥊u.ToNat 𝕩}

ex ← Parse "
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"

Part1 ← {
    x1 ← 0⊏𝕩
    y1 ← 1⊏𝕩
    x2 ← 2⊏𝕩
    y2 ← 3⊏𝕩

    keep ← (x1=x2) ∨ (y1=y2)
    x1 ↩ keep / x1
    y1 ↩ keep / y1
    x2 ↩ keep / x2
    y2 ↩ keep / y2

    width ← 1 + (⌈´x1) ⌈ ⌈´x2
    height ← 1 + (⌈´y1) ⌈ ⌈´y2

    xmin ← x1 ⌊¨ x2
    xmax ← x1 ⌈¨ x2
    ymin ← y1 ⌊¨ y2
    ymax ← y1 ⌈¨ y2

    xspan ← xmin {(𝕨≤↕width) ∧ (↕width)≤𝕩}¨ xmax
    yspan ← ymin {(𝕨≤↕width) ∧ (↕width)≤𝕩}¨ ymax

    prod ← xspan {𝕩∧⌜𝕨}¨ yspan
    sum ← +´prod
    +´⥊sum>1
}

Part2 ← { 𝕩 ⋄ "TODO" }

! 5=Part1 ex

parse‿part1‿part2 u.RunDay 5