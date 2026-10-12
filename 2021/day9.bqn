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

Neighbors ← { edgefill 𝕊 map:
    edgerow ← (1⊑≢map)⥊edgefill
    north ← edgerow»map
    south ← edgerow«map
    east ← edgefill«˘map
    west ← edgefill»˘map
    [north,south,east,west]
}

Part1 ← { 𝕊 map:
    lowPoints ← ∧˝map<⎉2(99 Neighbors map)
    +´⥊lowPoints×(map+1)
}

Part2 ← { 𝕊 map:
    # We fill an array with unique IDs and then repeatedly take the maximum of
    # neighboring cells until a fixed point is reached.
    validArea ← map≠9
    basinId ← 1+(≢map)⥊↕≠⥊map
    prevBasin ← 0
    basin ← validArea×basinId

    { 𝕤
        prevBasin ↩ basin
        neigh ← basin∾(0 Neighbors basin)
        # When we take the max of all neighbors, the 0s that represent the
        # boundaries between basins get some other value, so we have to
        # re-multiply by validArea to clear them again.
        basin ↩ validArea×⌈˝neigh
    }•_while_{𝕤 ⋄ basin≢prevBasin} @

    hist ← /⁼∧⥊basin
    basinSizes ← 1↓(hist≠0)/hist
    ×´3↑∨basinSizes
}

! 15=Part1 ex
! 1134=Part2 ex

parse‿part1‿part2 u.RunDay 9