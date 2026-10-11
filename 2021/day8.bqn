# I think a brute force solution is feasible (7! = 5,040), but I will try to
# logic puzzle it out:
#
# 1, 4, 7, and 8 are given, as the puzzle states.
#
# How many segments are on for each digit?
#
# 2 segments: 1
# 3 segments: 7
# 4 segments: 4
# 5 segments: 2, 3, 5
# 6 segments: 0, 6, 9
# 7 segments: 8
#
# If we know 4 and 8, then 9 is the digit other than 8 that has all of the
# segments that 4 does. Then between the remaining 6-segment digits, 0 and 6,
# 0 shares two segments with 1, so we know 0 and also 6.
#
# Of the 5-segment digits, only 3 has both "c" and "f", so given we know 1, we
# also know 3.
#
# Now it only remains to tell the difference between 2 and 5. If we take
# "8 xor 9" (both known), the result is "e". 2 has "e" set and 5 does not.

u ← •Import "util.bqn"
Parse ← {∘‿14⥊(¬𝕩∊u.ws∾"|") u.Extract 𝕩}
ex ← Parse "
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
fgae cfgab fg bagce
"

Part1 ← {+´⥊(≠¨¯4↑⍉𝕩)∊⟨2,3,4,7⟩}

RepOneHot ← {
    ! ∧´⥊1=+˝𝕨
    foo ← +˝𝕨×𝕩
    (≠𝕩)‿(≠foo)⥊foo
}

decAsBinary ← ⥊↕7⥊2

Subset ← {
    a ← 𝕨⊑decAsBinary
    b ← 𝕩⊑decAsBinary
    a≡a∧b
}

Part2 ← {
    t←⍉𝕩
    p←2⋆↕7
    nall←{+´𝕩⊏p}¨(t-'a')
    lenall←≠¨(t-'a')
    n←10↑nall
    codes ← 10↓nall
    len←10↑lenall

    d1 ← (len=2) RepOneHot n
    d7 ← (len=3) RepOneHot n
    d4 ← (len=4) RepOneHot n
    d8 ← (len=7) RepOneHot n
    d9 ← ((len=6)∧(d4 Subset¨ n)) RepOneHot n
    d0 ← ((len=6)∧(n≠d9)∧(d1 Subset¨ n)) RepOneHot n
    d6 ← ((len=6)∧(n≠d9)∧(n≠d0)) RepOneHot n
    d3 ← ((len=5)∧(d1 Subset¨ n)) RepOneHot n
    sege ← d8 - d9
    d2 ← ((len=5)∧(n≠d3)∧(sege Subset¨ n)) RepOneHot n
    d5 ← ((len=5)∧(n≠d2)∧(n≠d3)) RepOneHot n

    d ← >⊏¨⟨d0,d1,d2,d3,d4,d5,d6,d7,d8,d9⟩

    ansDigits ← (⍉d) ⊐˘ ⍉codes
    ansDec ← +˝(⍉ansDigits)×⌽10⋆↕4
    ans ← +´ansDec
}

! 26=Part1 ex
! 61229=Part2 ex

parse‿part1‿part2 u.RunDay 8