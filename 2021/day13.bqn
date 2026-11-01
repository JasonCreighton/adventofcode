u ← •Import "util.bqn"
Parse ← {
    dots‿folds ← (𝕩⊐'f') (↑⋈↓) 𝕩
    d ← ⍉∘‿2⥊u.ToNum dots
    f ← ⍉∘‿2⥊(folds∊"xy"∾u.digits) u.Extract folds
    dx ← 0⊏d
    dy ← 1⊏d
    cols ← 1+⌈´dx
    rows ← 1+⌈´dy
    paper ← 1¨⌾((dy⋈¨dx)⊸⊑) rows‿cols⥊0
    faxis ← 0⊏f
    fcoord ← •ParseFloat¨ 1⊏f
    paper‿faxis‿fcoord
}
ex ← Parse u.Trim "
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"

FoldUp ← { fl 𝕊 paper:
    ! (≠paper)=1+2×fl
    (fl↑paper) ∨ ⌽((-fl)↑paper)
}
FoldLeft ← {𝕨⊸FoldUp⌾⍉ 𝕩}
FoldFunc ← {(⟨"x","y"⟩⊐𝕩)⊏⟨foldleft,foldup⟩}

Part1 ← { 𝕊 paper‿faxis‿fcoord:
    f ← ⊑FoldFunc faxis
    +´⥊(⊑fcoord) F paper
}
RealPart2 ← { 𝕊 paper‿faxis‿fcoord:
    fc ← (FoldFunc faxis) ⋈¨ fcoord
    paper { f‿c 𝕊 p: c F p }´ ⌽fc
}

# Puzzle involves recognizing ASCII art lettering, we just hardcode the answer
Part2 ← {RealPart2 𝕩 ⋄ "BFKRCJZU"}

! 17=Part1 ex

parse‿part1‿part2 u.RunDay 13