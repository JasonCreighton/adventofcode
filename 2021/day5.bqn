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

IncAlongRows ← { field 𝕊 mask‿row‿col1‿col2:
    mr ← mask / row
    mc ← mask / col1
    mlen ← 1+(mask/col2)-mc
    m ← ⍉mr∾mc≍mlen
    {𝕊 r‿c‿len: field {𝕩+1}⌾((len⊸↑)∘(c⊸↓)∘(r⊸⊏))↩ ⋄ @}˘m
    field
}

CountIntersections ← { part 𝕊 tab:
    x1 ← 0⊏tab
    y1 ← 1⊏tab
    x2 ← 2⊏tab
    y2 ← 3⊏tab
    xmin ← x1⌊¨x2
    xmax ← x1⌈¨x2
    ymin ← y1⌊¨y2
    ymax ← y1⌈¨y2

    horz ← y1=y2
    vert ← x1=x2
    diag ← (part=2) ∧ (¬horz) ∧ ¬vert
    
    width ← 1+⌈´xmax
    height ← 1+⌈´ymax
    field ← width‿height⥊0                 # Transposed shape (will get flipped)
    field IncAlongRows↩ vert‿x1‿ymin‿ymax  # Vertical lines
    field ⍉↩                               # Transpose
    field IncAlongRows↩ horz‿y1‿xmin‿xmax  # Horizontal lines
    field ⥊↩                               # Deshape for diagonals

    # Diagonal lines are annoying. We use a flat "field" array so that we can
    # index individual locations with ⊏ (Otherwise I think we'd need ⊑ and that
    # would involve created nested arrays for the indices.)
    dx1 ← diag / x1
    dy1 ← diag / y1
    dx2 ← diag / x2
    dy2 ← diag / y2
    dlen ← 1+(diag/xmax)-(diag/xmin)
    doffset ← dx1+dy1×width
    dstride ← ((dx2>dx1)⊏⟨¯1,1⟩)+((dy2>dy1)⊏⟨0-width,width⟩)
    d ← ⍉doffset∾dlen≍dstride

    {𝕊 offset‿len‿stride: field {𝕩+1}⌾((offset+stride×↕len)⊸⊏)↩ ⋄ @}˘d

    +´field>1
}

Part1 ← 1⊸CountIntersections
Part2 ← 2⊸CountIntersections

! 5=Part1 ex
! 12=Part2 ex

parse‿part1‿part2 u.RunDay 5