u ← •Import "util.bqn"

# We just extract the constants under the assumption that the input looks like
# the one we hand inspected.
Parse ← {⍉⟨2,3,9⟩⊏⍉14‿10⥊u.ToNum 𝕩}

# Direct transliteration of the puzzle input to BQN code
ReferenceChunk ← { consts 𝕊 inp‿z:
    x ← 0
    y ← 0
    w ← inp
    x ↩ x × 0
    x ↩ x + z
    x ↩ 26|x
    z ↩ (××⌊∘|)z÷0⊑consts
    x ↩ x + 1⊑consts
    x ↩ x=w
    x ↩ x=0
    y ↩ y × 0
    y ↩ y + 25
    y ↩ y × x
    y ↩ y + 1
    z ↩ z × y
    y ↩ y × 0
    y ↩ y + w
    y ↩ y + 2⊑consts
    y ↩ y × x
    z ↩ z + y
    z
}

Chunk ← { consts 𝕊 inp‿z:
    # 0⊑consts = sometimes 1, sometimes 26
    zdiv ← (××⌊∘|)z÷0⊑consts
    zrem ← (26|z)
    cmpVal ← zrem + 1⊑consts
    valNeqInp ← ¬cmpVal=inp    
    zfactor ← (25 × valNeqInp) + 1
    zoffset ← (inp + 2⊑consts) × valNeqInp
    # If  valNeqInp, then zfactor=26 and zoffset=determined by inp and consts
    # If ¬valNeqInp, then zfactor=1  and zoffset=0
    #
    # In my puzzle input 2⊑consts is always non-negative, so I think zoffset
    # (and z) always have to be positive, since inp is positive.
    #
    # This implies zrem always non-negative, which means that anything with
    # (1⊑consts)>9 (which is 7 entries in my puzzle input) can't ever cause
    # ¬valNeqInp, and will end up with zfactor=26. So I think this means I
    # need to force ¬valNeqInp on the 7 entries where this is possible and try
    # to maximize the input digits on the other 7. (If I don't do this, then z
    # will get multiplied by 26 7 times, but divided by 26 fewer than 7 times,
    # and I don't see how to get back to zero if I don't multiply/divide by
    # 26 an equal number of times.)
    zout ← (zdiv × zfactor) + zoffset
    zout
}

testConsts ← ⟨1‿2‿3,¯1‿¯2‿¯3,10‿20‿30,3‿2‿1,¯30‿¯20‿¯10,3‿4‿5,5‿4‿3⟩
testVals ← (⥊↕10‿60)-¨<0‿30

! ∧´1=⥊testConsts {(𝕨 Chunk 𝕩)=(𝕨 ReferenceChunk 𝕩)}⌜ testVals

# May be outside [1,9], caller has to check
ForcedInput ← { consts 𝕊 z: (26|z)+1⊑consts }

Step ← { consts 𝕊 inp‿z:
    {
        (1⊑consts)>9 ?
            # Impossible for the a digit match to force zfactor=1
            # We try all 9 possibilites.
            newdigit ← (9×≠z)⥊1+↕9
            newinp ← (9/10×inp)+newdigit
            newz ← 9/z
            newinp‿(consts Chunk newdigit‿newz)
        ;
            # We may be able to force a match, depending on the current z
            # value. We discard any entries where a match is not possible.
            newdigit ← consts ForcedInput z
            m ← (newdigit≥1)∧(newdigit≤9)
            newinp ← (10×m/inp)+m/newdigit
            newz ← m/z
            newinp‿(consts Chunk (m/newdigit)‿newz)
    }
}

ValidModelNum ← { 𝕊 consts:
    model‿z ← ⟨0⟩‿⟨0⟩ Step´ ⌽<˘consts
    (z=0)/model
}

Part1 ← ⌈´ ValidModelNum
Part2 ← ⌊´ ValidModelNum

parse‿part1‿part2 u.RunDay 24