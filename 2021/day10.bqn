u ← •Import "util.bqn"
sep ← 99
braces ← "()[]{}<>"
braceCodes ← ⟨1,¯1,2,¯2,3,¯3,4,¯4,sep⟩
part1Points ← ⟨0,3,57,1197,25137⟩
Parse ← {(braces⊐𝕩)⊏braceCodes}
ex ← Parse "
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"

RemoveAdjPairs ← {
    openAdj ← (𝕩>0)∧𝕩=-«𝕩
    closeAdj ← »openAdj    
    (¬openAdj∨closeAdj)/𝕩
}

Reduce ← {
    prev ← 0
    flat ← {prev ↩ 𝕩 ⋄ RemoveAdjPairs 𝕩}•_while_{prev≢𝕩} 𝕩
    (flat≠sep) u.Extract flat
}

Part1Score ← {
    (⊑-((𝕩<0)/𝕩)∾0)⊑part1Points
}

Part1 ← { 𝕊 lines:
    +´ Part1Score¨ Reduce lines
}
Part2 ← { 𝕊 lines:
    r ← Reduce lines
    incomplete ← ({∧´𝕩>0}¨r)/r
    scored ← {+´𝕩×5⋆↕≠𝕩}¨ incomplete
    median ← (((≠scored)-1)÷2)⊑∧scored
    median
}

! 26397=Part1 ex
! 288957=Part2 ex

parse‿part1‿part2 u.RunDay 10