u ← •Import "util.bqn"
Parse ← {•ParseFloat¨u.SplitLines 𝕩}
Part1 ← {+´<˝˘2↕𝕩}
Part2 ← {Part1+˝˘3↕𝕩}

inp ← Parse u.GetInput 1
ex ← Parse "
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

! 7=Part1 ex
! 5=Part2 ex
(Part1 inp)‿(Part2 inp) u.CheckAns 1