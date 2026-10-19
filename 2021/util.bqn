ws ⇐ @+⟨9,10,13,32⟩
tab‿lf‿cr‿sp ⇐ ws
digits ⇐ "0123456789"
Trim ⇐ {
    s ← 𝕩∊ws
    (0-((⌽s)⊐0))↓(s⊐0)↓𝕩
}
Extract ⇐ { mask 𝕊 a:
    start ← /(¬»mask)∧mask
    end   ← /(¬«mask)∧mask
    (1+end-start) ↑¨ start ↓¨ <a
}
ExtractRect ⇐ { mask 𝕊 a:
    width ← ⊑((⊑mask⊐1)↓mask)⊐0
    ∘‿width⥊mask/a
}
ToNat ⇐ {•ParseFloat¨ (𝕩∊digits) Extract 𝕩}
_fix ⇐ { 𝔽 _fix v0:
    v1 ← 𝔽 v0
    prev ← v0
    𝔽•_while_{cont ← 𝕩≢prev ⋄ prev ↩ 𝕩 ⋄ cont} v1
}
GetInput ⇐ {•FChars ∾⟨"../../adventofcode-data/2021/input",•Fmt 𝕩,".txt"⟩}
ForceStr ← {0==𝕩 ? •Fmt 𝕩 ; 𝕩}
RunDay ⇐ { parse‿part1‿part2 𝕊 day:
    expected ← •FLines ∾⟨"../../adventofcode-data/2021/answers",•Fmt day,".txt"⟩
    rawInp ← GetInput day
    t0 ← •MonoTime 0 ⋄ inp ← Parse rawInp
    t1 ← •MonoTime 0 ⋄ ans1 ← Part1 inp
    t2 ← •MonoTime 0 ⋄ ans2 ← Part2 inp
    t3 ← •MonoTime 0
    t_us ← ⌊0.5+1e6×⟨t1-t0,t2-t1,t3-t2⟩
    •Show day∾t_us
    ans ← ForceStr¨ans1‿ans2
    (∾⟨"Day ",•Fmt 𝕩," mismatch: Expected ",•Repr expected,", got ",•Repr ans⟩)!ans≡expected
    t_us
}