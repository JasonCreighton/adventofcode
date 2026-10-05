RunDay ← {
    bqnFile ← ∾⟨"day",•Fmt 𝕩,".bqn"⟩
    t_ms ← ⌊0.5+1e3×{•Import 𝕩}•_timed bqnFile
    •Out ∾⟨"Day ",•Fmt 𝕩,": ",•Fmt t_ms," [ms]"⟩
}

RunDay¨1+↕25