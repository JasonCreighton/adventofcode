# The puzzle is stated in terms of overlapping pairs producing extra
# characters. I reformulate this to non-overlapping pairs producing other
# non-overlapping pairs.
#
# For example, the rule "CH -> B", I regard as "CH -> {CB, BH}", where CH
# produces two other pairs CB, BH. It then becomes much clearer to me how to
# apply dynamic programming, which I do in a bottom-up formulation.
#
# To produce answers in the form expected by the puzzle, note that every letter
# in the "polymer" is double-counted (ie, present in two of my non-overlapping
# pairs), except for the very first and last letters. I can find the answer for
# the non-overlapping case, and then adjust it slightly to get the expected
# convention.

u ← •Import "util.bqn"
Parse ← {
    template‿rules ← (𝕩⊐u.lf) (↑⋈↓) 𝕩
    t ← u.Trim template
    r ← ⍉∘‿2⥊(¬rules∊"->"∾u.ws) u.Extract rules
    from ← 0⊏r
    to ← ⊑¨1⊏r # characters
    toidx ← from {from⊐⟨⟨0⊑𝕨,𝕩⟩,⟨𝕩,1⊑𝕨⟩⟩}¨ to
    t‿from‿toidx
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

Step ← { toidx 𝕊 totals: {+´𝕩⊏totals}¨ toidx }

TemplateScore ← { tmpl‿from‿toidx 𝕊 steps:
    initial ← {26↑/⁼∧𝕩-'A'}¨ from
    totals ← toidx⊸Step⍟steps initial
    pairs ← <˘2↕tmpl
    raw ← +´(from⊐pairs)⊏totals
    fudge ← 26↑/⁼∧(0‿¯1⊏tmpl)-'A'
    adj ← (raw+fudge)÷2
    ! adj≡⌊adj
    mostCommon ← ∨>⟜0⊸/adj
    (0⊑mostCommon) - 0⊑⌽mostCommon
}

Part1 ← TemplateScore⟜10
Part2 ← TemplateScore⟜40

! 1588=Part1 ex
! 2188189693529=Part2 ex

parse‿part1‿part2 u.RunDay 14