# I originally had a slow DFS here, and I replaced it with a BFS very directly
# inspired by dzaima's solution:
# https://github.com/dzaima/aoc/blob/c978147121006eb90d68db18a383a88dcfb90812/2021/BQN/12.bqn

u ← •Import "util.bqn"
Parse ← {
    tab ← ⍉∘‿2⥊(¬𝕩∊'-'∾u.ws) u.Extract 𝕩
    fromname ← (0⊏tab)∾1⊏tab
    toname   ← (1⊏tab)∾0⊏tab
    name ← ⍷fromname∾toname
    start‿end ← name⊐⟨"start","end"⟩
    from ← name⊐fromname
    to   ← name⊐toname
    sm ← {∧´(𝕩≥'a')∧𝕩≤'z'}¨ name
    map ← {(from=𝕩)/to}¨↕≠name

    map‿sm‿start‿end
}

ex1 ← Parse "
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"
ex2 ← Parse "
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"
ex3 ← Parse "
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"

PathsToEnd ← { part 𝕊 map‿sm‿start‿end:
    caves ← (↕≠map) (¬∘∊/⊣) ⟨start,end⟩
    eye ← =⌜˜↕≠map
    Step ← { 𝕊 count‿vmask‿sse‿loc:
        nested ← { 𝕊 dest:
            adj ← loc∊dest⊑map
            ok ← (¬dest⊑sm)∨¬dest⊏˘vmask
            sel ← adj∧ok∨sse
            ⟨(dest⊏eye)∨⎉1 sel/vmask,sel/sse∧ok,(+´sel)⥊dest⟩
        }¨ caves
        ⟨count++´loc∊end⊑map,∾0⊸⊑¨nested,∾1⊸⊑¨nested,∾2⊸⊑¨nested⟩
    }
    0⊑Step•_while_{𝕊 c‿v‿s‿loc: 0≠≠loc} ⟨0,1‿(≠map)⥊0,⟨part=2⟩,⟨start⟩⟩
}

Part1 ← {1 PathsToEnd 𝕩}
Part2 ← {2 PathsToEnd 𝕩}

! 10=Part1 ex1
! 19=Part1 ex2
! 226=Part1 ex3
! 36=Part2 ex1
! 103=Part2 ex2
! 3509=Part2 ex3

parse‿part1‿part2 u.RunDay 12