s ← •Import "bqn-libs/strings.bqn"
SplitLines ⇐ {{(0≠≠¨𝕩)/𝕩} s.crlf s.Split 𝕩}
GetInput ⇐ {•FChars ∾⟨"../../adventofcode-data/2021/input",•Fmt 𝕩,".txt"⟩}
ForceStr ← {0==𝕩 ? •Fmt 𝕩 ; 𝕩}
CheckAns ⇐ {
    expected ← •FLines ∾⟨"../../adventofcode-data/2021/answers",•Fmt 𝕩,".txt"⟩
    ans ← ForceStr¨𝕨
    (∾⟨"Day ",•Fmt 𝕩," mismatch: Expected ",•Repr expected,", got ",•Repr ans⟩)!ans≡expected
}