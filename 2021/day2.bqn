u ← •Import "util.bqn"

Parse ← {
    tab ← ⍉>{" " u.Split 𝕩}¨ u.SplitLines 𝕩
    dir ← 0⊏tab
    mag ← •ParseFloat¨1⊏tab
    fwd ← mag×{"forward"≡𝕩}¨dir
    down ← mag×{"down"≡𝕩}¨dir
    up ← mag×{"up"≡𝕩}¨dir
    fwd‿down‿up
}

Part1 ← { 𝕊 fwd‿down‿up:
    h ← +´fwd
    d ← +´down-up
    h×d
}

Part2 ← { 𝕊 fwd‿down‿up:
    a ← +`down-up
    h ← +´fwd
    d ← +´a×fwd
    h×d
}

ex ← Parse "
forward 5
down 5
forward 8
up 3
down 8
forward 2
"

! 150=Part1 ex
! 900=Part2 ex

inp ← Parse u.GetInput 2
(Part1 inp)‿(Part2 inp) u.CheckAns 2