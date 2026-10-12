u ← •Import "util.bqn"
braces ← "()[]{}<>"
braceCodes ← ⟨1,¯1,2,¯2,3,¯3,4,¯4⟩
bracePoints ← ⟨0,3,57,1197,25137⟩
Parse ← {{(braces⊐𝕩)⊏braceCodes}¨ (𝕩∊"()[]{}<>") u.Extract 𝕩}
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
    {prev ↩ 𝕩 ⋄ RemoveAdjPairs 𝕩}•_while_{prev≢𝕩} 𝕩
}

Score ← {
    (⊑-((𝕩<0)/𝕩)∾0)⊑bracePoints
}

Part1 ← { 𝕊 lines:
    +´ {Score Reduce 𝕩}¨ lines
}
Part2 ← {𝕤 ⋄ "TODO"}

! 26397=Part1 ex

parse‿part1‿part2 u.RunDay 10