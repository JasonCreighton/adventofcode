u ← •Import "util.bqn"
hexDigits ← "0123456789ABCDEF"
hexAsBinary ← >⥊↕4⥊2
bigEndian ← ⌽2⋆↕15
HexToBin ← {⥊hexAsBinary⊏˜<⟜16⊸/hexDigits⊐𝕩}
BinToDec ← {
    ! (≠𝕩)≤≠bigEndian
    +´𝕩×(-≠𝕩)↑bigEndian
}
MakeReader ← {𝕊 input:
    pos ⇐ 0
    Read ⇐ {𝕊 len:
        val ← BinToDec len↑pos↓input
        pos +↩ len
        val
    }
}
Literal ← { in 𝕊 prevn:
    cont ← in.Read 1
    grp ← in.Read 4
    n ← (prevn×16)+grp
    { cont ? in Literal n ; n }
}
SubPacketsBits ← { 𝕊 in:
    len ← in.Read 15
    endPos ← in.pos + len
    packets ← ⟨⟩
    { 𝕊: packets ∾↩<Packet in}•_while_{ 𝕊:in.pos<endPos } @
    packets
}
SubPacketsCount ← {𝕊 in: {𝕊: Packet in}¨↕in.Read 11}
Operator ← { 𝕊 in:
    lentype ← in.Read 1
    { lentype ? SubPacketsCount in; SubPacketsBits in }
}
Packet ← { 𝕊 in:
    version ← in.Read 3
    type ← in.Read 3
    body ← { type=4 ? in Literal 0 ; Operator in }
    ⟨version,type,body⟩
}
Parse ← {Packet MakeReader HexToBin 𝕩}
! ⟨6,4,2021⟩≡Parse "D2FE28"
! ⟨1,6,⟨⟨6,4,10⟩,⟨2,4,20⟩⟩⟩≡Parse "38006F45291200"
! ⟨7,3,⟨⟨2,4,1⟩,⟨4,4,2⟩,⟨1,4,3⟩⟩⟩≡Parse "EE00D40C823060"

SumVersions ← { 𝕊 ver‿type‿body:
    { type=4 ? ver ; ver++´{SumVersions 𝕩}¨body }
}
_binop ← { (0⊑𝕩) 𝔽 (1⊑𝕩) }
evalFuncs ← ⟨+´,×´,⌊´,⌈´,@,>_binop,<_binop,=_binop⟩
Eval ← {
    𝕊 ver‿4‿literal: literal ;
    𝕊 ver‿type‿body: f ← type⊑evalFuncs ⋄ F Eval¨ body
}
Part1 ← SumVersions
Part2 ← Eval

ex1 ← Parse "8A004A801A8002F478"
ex2 ← Parse "620080001611562C8802118E34"
ex3 ← Parse "C0015000016115A2E0802F182340"
ex4 ← Parse "A0016C880162017C3686B18A3D4780"

! 16=Part1 ex1
! 12=Part1 ex2
! 23=Part1 ex3
! 31=Part1 ex4

parse‿part1‿part2 u.RunDay 16