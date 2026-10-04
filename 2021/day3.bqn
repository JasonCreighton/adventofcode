u ← •Import "util.bqn"

Parse ← {'1'=>u.SplitLines 𝕩}
Bin2Dec ← {+´𝕩×⌽2⋆↕≠𝕩}
Part1 ← {
    gamma ← (+˝𝕩)>(≠𝕩)÷2
    epsilon ← ¬gamma
    (Bin2Dec gamma) × Bin2Dec epsilon
}
Part2 ← {𝕩 ⋄ "TODO"}

ex ← Parse "
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"

! 198=Part1 ex
# ! 230=Part2 ex

inp ← Parse u.GetInput 3
(Part1 inp)‿(Part2 inp) u.CheckAns 3