# Note that the x and y position calculations are separable.
#
# Part 1:
#
# Hand-wavey hand solution: From the examples, it seems like there will always
# be a point in time where the probe has reached y=0 again after being
# launched upwards. So the highest altitude is reached when you select the
# initial velocity such that on the timestep after reaching y=0, the probe
# reaches y=<lowest y coord in target>.
#
# In the example given, the target's lowest y value is -10, so we want dy=-10
# at the x-axis crossing, which means we start with dy=9.
#
# Then the height is given by the sum of 1 to dy, or (dy*(1+dy))/2, or h=45 in
# the example.

u ← •Import "util.bqn"
Parse ← u.ToNum
ex ← Parse "target area: x=20..30, y=-10..-5"

# Per hand solution given above
MaxDY ← {𝕊 x1‿x2‿y1‿y2: (-y1)-1}
! 9=MaxDY ex

Part1 ← {
    dy ← MaxDY 𝕩
    (dy×(dy+1))÷2
}
Part2 ← {𝕊 ⋄ "TODO"}

! 45=Part1 ex

parse‿part1‿part2 u.RunDay 17