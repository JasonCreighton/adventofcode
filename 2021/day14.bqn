u ← •Import "util.bqn"
Parse ← {
    template‿rules ← (𝕩⊐u.lf) (↑⋈↓) 𝕩
    t ← u.Trim template
    r ← ⍉∘‿2⥊(¬rules∊"->"∾u.ws) u.Extract rules
    from ← 0⊏r
    to ← 1⊏r
    t‿from‿to
}
ex ← Parse u.Trim "
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"

Step ← { from‿to 𝕊 t:
    insert ← (¯1↓from⊐(t⋈¨«t))⊏to
    tstrs ← 1↑¨(↕≠t)↓¨<t
    ∾(⥊(¯1↓tstrs)≍˘insert)∾¯1↑tstrs
}
! "NCNBCHB"≡{t‿from‿to ← ex ⋄ from‿to Step t}

Part1 ← { 𝕊 t‿from‿to:
    polymer ← from‿to⊸Step⍟10 t
    hist ← ∨0⊸≠⊸//⁼∧polymer-@
    (0⊑hist) - 0⊑⌽hist
}
Part2 ← {𝕩 ⋄ "TODO"}

! 1588=Part1 ex

parse‿part1‿part2 u.RunDay 14