u ← •Import "util.bqn"
Small ← {∧´(𝕩≥'a')∧𝕩≤'z'}
Parse ← {
    raw ← ⍉∘‿2⥊(¬𝕩∊'-'∾u.ws) u.Extract 𝕩
    from ← (0⊏raw)∾1⊏raw
    to   ← (1⊏raw)∾0⊏raw
    sm   ← Small¨ to
    # Remove edges to "start" or from "end"
    keep ← ¬(from≡¨<"end")∨(to≡¨<"start")
    (keep/from)‿(keep/to)‿(keep/sm)
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

PathsToEnd ← { part 𝕊 from‿to‿sm:
    Part1DestOk ← { path 𝕊 loc: ¬sm∧to∊path}
    Part2DestOk ← { path 𝕊 loc:
        effpath ← path∾<loc
        smtwice ← ∨´Small¨ (0<⊒effpath)/effpath
        effsm ← sm∧smtwice
        ¬effsm∧to∊effpath
    }
    destok ← { part=1 ? part1destok ; part2destok }
    Go ← {
        # Base case
        path 𝕊 "end": ⟨path∾⟨"end"⟩⟩ ;
        # Recursive case
        path 𝕊 loc:
            mask ← (from≡¨<loc)∧(path DestOk loc)
            dests ← mask/to
            ∾{(path∾⟨loc⟩) Go 𝕩}¨dests
    }
    ⟨⟩ Go "start"
}

Part1 ← {≠1 PathsToEnd 𝕩}
Part2 ← {≠2 PathsToEnd 𝕩}

! 10=Part1 ex1
! 19=Part1 ex2
! 226=Part1 ex3
! 36=Part2 ex1
! 103=Part2 ex2
! 3509=Part2 ex3

parse‿part1‿part2 u.RunDay 12