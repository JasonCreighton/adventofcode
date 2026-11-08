# Just doing something stupid so I can see what part 2 is.

u ← •Import "util.bqn"
Parse ← { ⟨1,3⟩⊏u.ToNum 𝕩 }

ex ← Parse "
Player 1 starting position: 4
Player 2 starting position: 8
"

Score ← { startpos 𝕊 rolls:
    space ← 1+10|+`(startpos-1)∾rolls
    score ← startpos-˜+`space
}

Part1 ← { 𝕊 pos:
    n ← 5000
    rolls ← +˝˘∘‿3⥊1+100|↕6×n
    p1rolls ← rolls⊏˜0+2×↕n
    p2rolls ← rolls⊏˜1+2×↕n
    p1score ← (0⊑pos) Score p1rolls
    p2score ← (1⊑pos) Score p2rolls

    p1win ← ⊑(p1score≥1000)⊐1
    p2win ← ⊑(p2score≥1000)⊐1

    win ← p1win⌊p2win
    winscore ← { p1win < p2win ? p1score ; p2score }
    losescore ← { p1win < p2win ? p2score ; p1score }

    dicerolls ← 3×1+2×win-1
    dicerolls×(win-1)⊑losescore
}

Part2 ← { 𝕩 ⋄ "TODO" }

! 739785=Part1 ex

parse‿part1‿part2 u.RunDay 21