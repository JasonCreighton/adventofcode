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

diceOutcomes ← ⟨3‿1,4‿3,5‿6,6‿7,7‿6,8‿3,9‿1⟩ # movement‿frequency

memo ← ⟨⟩ •HashMap ⟨⟩
DiracWinLoss ← { 𝕊 key:
    # "us" is the side-to-move, "them" is the other side
    uspos‿thempos‿usscore‿themscore ← key
    {
        # Base cases:
        usscore  ≥21 ? ⟨1,0⟩ ;
        themscore≥21 ? ⟨0,1⟩ ;
        # Already seen:
        memo.Has key ? memo.Get key ;
        # Not-yet-seen, recursive case:
        res ← +´ {𝕊 roll‿freq:
            p ← 1+10|roll+uspos-1
            # Swap side-to-move for recursive call
            them‿us ← DiracWinLoss thempos‿p‿themscore‿(usscore+p)
            ⟨freq×us,freq×them⟩
        }¨ diceOutcomes
        key memo.Set res
        res
    }
}

Part2 ← { 𝕊 p1‿p2: ⌈´ DiracWinLoss p1‿p2‿0‿0 }

! 739785=Part1 ex
! 444356092776315=Part2 ex

parse‿part1‿part2 u.RunDay 21