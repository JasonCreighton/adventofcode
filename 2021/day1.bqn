u ← •Import "util.bqn"
Parse ← {u.ToNat 𝕩}
Part1 ← {+´<˝˘2↕𝕩}
Part2 ← {Part1+˝˘3↕𝕩}

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

parse‿part1‿part2 u.RunDay 1