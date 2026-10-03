s ← •Import "bqn-libs/strings.bqn"
SplitLines ← {{(0≠≠¨𝕩)/𝕩} s.crlf s.Split 𝕩}
Parse ← {•ParseFloat¨SplitLines 𝕩}
Part1 ← {+´<˝˘2↕𝕩}
Part2 ← {Part1+˝˘3↕𝕩}

inp ← •ParseFloat¨•FLines "../../adventofcode-data/2021/input1.txt"
ans ← •FLines "../../adventofcode-data/2021/answers1.txt"
example ← Parse "
199
200
208
210
200
207
240
269
260
263
"

! 7=Part1 example
! 5=Part2 example
! ans≡•Repr¨ (Part1 inp)‿(Part2 inp)