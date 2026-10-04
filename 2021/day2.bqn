u ← •Import "util.bqn"

vecName ← ⟨"forward","down","up"⟩
vec ← ⟨1‿0,0‿1,0‿¯1⟩

Parse ← {
    tab ← ⍉>{" " u.Split 𝕩}¨ u.SplitLines 𝕩
    dirNames ← 0⊏tab
    dirs ← (vecName ⊐ dirNames) ⊏ vec
    mags ← •ParseFloat¨1⊏tab
    dirs×mags
}
Part1 ← ×´+´

ex ← Parse "
forward 5
down 5
forward 8
up 3
down 8
forward 2
"

! 150=Part1 ex

inp ← Parse u.GetInput 2
(Part1 inp)‿"TODO" u.CheckAns 2