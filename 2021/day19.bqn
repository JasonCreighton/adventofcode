u ← •Import "util.bqn"
Parse ← {
    nl ← 𝕩=u.lf
    minus ← 𝕩='-'
    start ← /(1»nl)∧minus∧«minus
    end ← ((≠𝕩)-1)«start
    chunk ← (1+end-start) ↑¨ start ↓¨ <𝕩
    {∘‿3⥊1↓u.ToNum 𝕩}¨ chunk
}
ex ← Parse "
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
"

Perm ← {
    𝕊 ⟨e⟩: ⟨e⟩ ;
    𝕊 a:
       ∾{
            head‿tail ← 1(↑⋈↓)𝕩⌽a
            {head∾𝕩}¨ Perm tail
        }¨ ↕≠a
}
# TODO: Puzzle text says 24 orientations, I get 48. (I think left/right
# mirroring from the perspective of the "camera" is being neglected by the
# puzzle?)
axisOrderings ← 8/>Perm ↕3
bin ← 8‿3⥊>↕2‿2‿2
axisFlips ← 48‿3⥊bin-bin=0
Rot ← { i 𝕊 vec:
    (i⊏axisFlips)×(i⊏axisOrderings)⊏vec
}
FindRot ← { orig 𝕊 rotated:
    allrot ← (↕48) Rot orig
    ⊑allrot⊐rotated
}
identityTransfrom ← ⟨0,0,0⟩‿7
Transform ← { offset‿r 𝕊 vec:
    offset+(r Rot vec)
}
! ⟨1,2,3⟩≡identityTransfrom Transform ⟨1,2,3⟩

Dist ← {
    n ← ≠𝕩
    a ← n/𝕩
    b ← ∾˝>n⥊<𝕩
    allDist ← •internal.Squeeze +˝˘×˜a-b # TODO: Why is squueze needed to get i32 type?
    keep ← (alldist≠0)∧∊allDist
    # keep ← 1⥊˜≢allDist
    ⟨keep/allDist,keep/a,keep/b⟩
}

Fingerprint ← { 𝕊 sc:
    pointDist ← {
        vec ← 𝕩 -⎉1 sc
        # Make sure each vector between points doesn't contain any zeros or
        # duplicates in its elementwise absolute value: We need unique elements
        # in order to disambiguate the relative orientation of the coordinate
        # systems.
        elemuniq ← {(∧´𝕩≠0)∧3=≠⍷𝕩}¨ <˘|vec
        # Not sure why squeeze is needed here, but if we don't we get an f64
        # array even though the data fits in an i32.
        •internal.Squeeze +˝˘×˜ elemuniq/vec
    }¨ <˘sc
    allDist ← ⍷∾pointDist
    sc‿pointDist‿allDist
}

TransformBetweenScanners ← { tform0 𝕊 fp0‿fp1:
    sc0‿pd0‿ad0 ← fp0
    sc1‿pd1‿ad1 ← fp1

    # Find the two points in Sc0 (the known scanner) that are the closest match
    # to Sc1.
    bestPointsInSc0 ← 2↑⍒{+´𝕩∊ad1}¨ pd0
    # Find the two points in Sc1 (the to-be-resolved scanner) that correspond
    # to the points in Sc0 by taking the points that having the largest overlap
    # in distance signatures.
    matchingPointsInSc1 ← {𝕊 p: ⊑⍒{+´𝕩∊p}¨pd1}¨ bestPointsInSc0⊏pd0
    
    # We apply tform0 to a0, b0, so that all the scanners get referenced back
    # to a common coordinate system.
    a0‿b0 ← (<tform0) Transform¨ <˘bestPointsInSc0⊏sc0
    a1‿b1 ← <˘matchingPointsInSc1⊏sc1

    # We believe that a0=a1 and b0=b1, except for a coordinate transformation
    v0 ← b0-a0
    v1 ← b1-a1

    # So now v1 should be some sign-flipped, permuted version of v0
    # TODO: Why isn't this v0 FindRot v1???
    sc1rot ← v1 FindRot v0
    "Should have found a valid rotation of v0 to v1" ! sc1rot<48

    # Similarly, we use sc0's offset to place sc1's offset in the same
    # coordinate system.
    sc1offset ← a0 - (sc1rot Rot a1)

    sc1offset‿sc1rot
}

AllScannerTransforms ← { 𝕊 fp:
    tform ← @⥊˜≠fp
    match ← 0⥊˜≠fp
    with ← 0⥊˜≠fp

    tform identityTransfrom⌾(0⊸⊑)↩

    # TODO: Basically duplicated in the loop
    match ↩ (<2⊑0⊑fp) {+´𝕨∊2⊑𝕩}¨ fp
    { 𝕊:
        # Pick scanner with the best match to a resolved scanner as the next one
        # to resolve.
        i ← ⊑⍒(match×tform≡¨@)
        tform0 ← (i⊑with)⊑tform
        fp0 ← (i⊑with)⊑fp
        fp1 ← i⊑fp

        newtform ← tform0 TransformBetweenScanners fp0‿fp1
        tform newtform⌾(i⊸⊑)↩

        newmatch ← (<2⊑fp1) {+´𝕨∊2⊑𝕩}¨ fp
        newwith ← i⥊˜≠fp    
        improved ← newmatch>match
        match ↩ (newmatch×improved)+(match×¬improved)
        with  ↩ (newwith ×improved)+(with ×¬improved)
    }¨↕1-˜≠fp

    "All transforms should have been found" ! ∧´tform≢¨@
    "All matches should have ended up non-zero" ! ∧´match>0

    tform
}

Part1 ← {
    fp ← Fingerprint¨ 𝕩
    tform ← AllScannerTransforms fp
    ≠⍷∾tform {(<𝕨) Transform¨ <˘⊑𝕩}¨ fp
}
Part2 ← {
    fp ← Fingerprint¨ 𝕩
    tform ← AllScannerTransforms fp
    ⌈´⥊{+´|𝕨-𝕩}⌜˜ ⊑¨ tform
}

! 79=Part1 ex
! 3621=Part2 ex

parse‿part1‿part2 u.RunDay 19