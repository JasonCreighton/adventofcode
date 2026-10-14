u ← •Import "util.bqn"
Parse ← {
    digits ← 𝕩∊"0123456789"
    firstLineLen ← ⊑digits⊐0
    ∘‿firstLineLen⥊digits/𝕩-'0'
}
ex ← Parse u.Trim "
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"

Step ← { 𝕊 energy‿numFlashes:
    s1 ← energy+1
    flashed ← (≢s1)⥊0
    s2 ← {
        flash ← 𝕩>9
        lr ← («˘flash) + »˘flash
        ud ← (« flash) + » flash
        corners ← («lr) + »lr
        adj ← lr + ud + corners
        flashed ∨↩ flash
        (¬flashed)∧𝕩+adj
    }•_while_{∨´⥊𝕩>9} s1

    s2‿(numFlashes++´⥊flashed)
}

Part1 ← {1⊑Step⍟100 𝕩‿0}
Part2 ← {
    n ← 0
    prevf ← 0
    { 𝕊 e‿f:
        prevf ↩ f
        n +↩ 1
        Step e‿f
    }•_while_{ 𝕊 e‿f: f≠prevf+≠⥊e} 𝕩‿0
    n
}

! 1656=Part1 ex
! 195=Part2 ex

parse‿part1‿part2 u.RunDay 11