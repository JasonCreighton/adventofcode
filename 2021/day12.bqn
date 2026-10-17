u ← •Import "util.bqn"
Small ← {𝕩<0}
start ← ¯1
end ← ¯2
Parse ← {
    tab ← ⍉∘‿2⥊(¬𝕩∊'-'∾u.ws) u.Extract 𝕩
    fromname ← (0⊏tab)∾1⊏tab
    toname   ← (1⊏tab)∾0⊏tab
    name ← ⍷fromname∾toname
    start‿end ← name⊐⟨"start","end"⟩
    from ← name⊐fromname
    to   ← name⊐toname
    sm ← {∧´(𝕩≥'a')∧𝕩≤'z'}¨ name
    fromto ← {𝕊 f: (≠name)↑/⁼((from=f)∧(from≠end)∧to≠start)/to}¨↕≠name

    fromto‿sm‿start‿end
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

PathsToEnd ← { part 𝕊 fromto‿sm‿start‿end:
    Part1DestOk ← { visited 𝕊 loc: (¬sm)∨visited=0}
    Part2DestOk ← { visited 𝕊 loc:
        smtwice ← ∨´sm∧visited=2
        effsm ← sm∧smtwice
        (¬effsm)∨visited=0
    }
    destok ← { part=1 ? part1destok ; part2destok }
    Go ← {
        # Base case
        visited 𝕊 loc: loc=end ? 1 ;
        # Recursive case
        visited 𝕊 loc:
            dests ← /(loc⊑fromto)∧(visited DestOk loc)
            +´{(1⊸+⌾(𝕩⊸⊏) visited) Go 𝕩}¨dests
    }
    ((≠fromto)⥊0) Go start
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