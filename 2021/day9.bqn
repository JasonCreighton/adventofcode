u ← •Import "util.bqn"
Parse ← {
    digits ← 𝕩∊"0123456789"
    firstLineLen ← ⊑digits⊐0
    ∘‿firstLineLen⥊digits/𝕩-'0'
}
ex ← Parse u.Trim "
2199943210
3987894921
9856789892
8767896789
9899965678
"

Part1 ← { 𝕊 map:
    inf ← 99
    infrow ← (1⊑≢map)⥊inf
    north ← infrow»map
    south ← infrow«map
    east ← inf«˘map
    west ← inf»˘map
    lowPoints ← (map<north)∧(map<south)∧(map<east)∧(map<west)
    +´⥊lowPoints×(map+1)
}
Part2 ← { 𝕩 ⋄ "TODO" }

! 15=Part1 ex

parse‿part1‿part2 u.RunDay 9