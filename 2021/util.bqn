ws ⇐ @+⟨9,10,13,32⟩
tab‿lf‿cr‿sp ⇐ ws
Trim ⇐ {
    s ← 𝕩∊ws
    (0-((⌽s)⊐0))↓(s⊐0)↓𝕩
}
Extract ⇐ { mask 𝕊 a:
    start ← /(¬»mask)∧mask
    end   ← /(¬«mask)∧mask
    (1+end-start) ↑¨ start ↓¨ <a
}
Split ⇐ {(¬𝕩∊𝕨) Extract 𝕩}
ToNat ⇐ {•ParseFloat¨ (𝕩∊"0123456789") Extract 𝕩}
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
}