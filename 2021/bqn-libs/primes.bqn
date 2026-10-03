⟨
  PrimesTo
  PrimesIn, SieveSegment
  NextPrime, PrevPrime
  IsPrime
  Pi
  NthPrime
  Factor, FactorExponents
  FactorCounts
  Totient
⟩⇐

# Prime state, updated as necessary
next ← 16
primes ← (¬∘∊/⊣)⟜(⥊×⌜˜)2↓↕next
wlen ← ≠primes

# Wheel factorization
⟨Sieve, Extend⟩ ← {
  seg ← 2⋆18                   # Maximum segment size
  wl ← ×´primes                # Wheel length
  mask ← ∧´(wl⥊0<↕)¨primes     # Positions not divisible by a prime
  # The extended wheel spans an extra ⌈seg÷next entries to let selections
  # run off the end instead of wrapping around
  em ← (wl + ⌈seg÷next) ⥊ mask # Extended mask
  ms ← +`em                    # Indices into wheel
  w ← /em                      # Extended wheel

  # Get prime mask on segment [start,end) with prime divisors pd
  # Assumes pd doesn't intersect primes, or [start,end)
  Sieve ⇐ {pd 𝕊 start‿end:
    d ← ⌊(𝕩-1)÷⌜pd             # Start and end coefficients to mark off
    b ← wl × (⊏d) ⌊∘÷ wl       # Round start down to nearest wheel
    [e,f] ← (d -⎉1 b) ⊏ ms     # As indices into extended wheel
    r ← f-e                    # Number of indices
    k ← ↕∘≠⊸+r/f-+`r           # Full wheel index list
    i ← (r/pd) × (r/b) + k⊏w
    0¨⌾((i-start)⊸⊏) (end-start)⥊start⌽mask
  }

  AddSeg ← {primes ∾↩ (⊑𝕩) + / (wlen↓𝕨↑primes) Sieve 𝕩 ⋄ @}
  Extend ⇐ {
    𝕩 ≤ next ? @ ;
    req ← 𝕩 ⌊ sq ← ×˜ next
    stops ← sq ⌊ (1+↕∘⌈)⌾((next+seg⊸×)⁼) req
    (primes ⍋ √stops) AddSeg¨ (next»stops)⋈¨stops
    next ↩ ⊢´ stops
    𝕊 𝕩
  }∘⌊
}

CheckNum  ← "Argument must be a non-negative number" ! (1=•Type)◶⟨0,0⊸≤⟩
CheckNat  ← "Argument must be a natural number" ! (1=•Type)◶⟨0,|∘⌊⊸=⟩

PrimesTo ← {
  CheckNum 𝕩
  Extend 𝕩
  primes (⍋↑⊣) ⌊𝕩
}

_getSegment ← {ind _𝕣:
  PRange ← { primes (⊣⊏˜·(⊣+↕∘-˜)´⍋) 𝕩-1 }
  sn ← {⊑∘⊢+/∘𝕏}⍟𝕗 sieve
  pr ← {-˜´ ↑ ·/⁼𝕏-⊑}⍟(¬𝕗) prange
  S ← {pd 𝕊 s‿e:
    n ← next⌊e
    (PR s‿n) ∾ <´◶⟨⟨⟩,pd⊸SN⟩ n‿e
  }
  # IsPrime¨⊸(𝕗◶⊣‿/) start(⊣+↕∘-˜)end
  {𝕊 start‿end:
    CheckNat¨ 𝕩
    "Range must be ordered" ! ≤´𝕩
    (wlen ↓ PrimesTo √end-1) (next≤start)◶S‿SN 𝕩
  }
}
SieveSegment ← 0 _getSegment  # IsPrime¨   (⊣+↕∘-˜)´
PrimesIn     ← 1 _getSegment  # IsPrime¨⊸/ (⊣+↕∘-˜)´

NextPrime ← {        (0<≠)◶⟨𝕊1⊑R,  ⊑ ⟩ PrimesIn r←  𝕩+1‿65 }⚇0
PrevPrime ← { !2<𝕩 ⋄ (0<≠)◶⟨𝕊0⊑R,¯1⊑⊢⟩ PrimesIn r←1⌈𝕩-64‿0 }⚇0

IsPrime ← {
  CheckNat 𝕩
  p ← 2‿3‿5‿7
  c ← 0=p|𝕩
  (∨´c)◶⟨(×˜¯1⊑p)⊸<◶⟨1⊸≠,MillerRabin⟩, c⊑∘/⟜p⊸=⊢ ⟩ 𝕩
}⚇0

# Compute n|𝕨×𝕩 in high precision
_modMul ← { n _𝕣:
  # Split each argument into two 26-bit numbers, with the remaining
  # mantissa bit encoded in the sign of the lower-order part.
  q←1+2⋆27
  Split ← { h←(q×𝕩)(⊣--)𝕩 ⋄ ⟨𝕩-h,h⟩ }
  # The product, and an error relative to precise split multiplication.
  Mul ← × (⊣ ⋈ -⊸(+´)) ·⥊×⌜○Split
  ((n×<⟜0)⊸+ -⟜n+⊢)´ n | Mul
}
MillerRabin ← { 𝕊 n:
  # n = 1 + d×2⋆s
  s ← 0 {𝕨 2⊸|◶⟨+⟜1𝕊2⌊∘÷˜⊢,⊣⟩ 𝕩} n-1
  d ← (n-1) ÷ 2⋆s

  # Arithmetic mod n
  Mul ← n _modMul
  Pow ← Mul{𝔽´𝔽˜⍟(/2|⌊∘÷⟜2⍟(↕1+·⌊2⋆⁼⊢)𝕩)𝕨}

  # Miller-Rabin test
  MR ← {
       1 =𝕩 ? 𝕨≠s ;
    (n-1)=𝕩 ? 0   ;
        𝕨≤1 ? 1   ;
    (𝕨-1) 𝕊 Mul˜𝕩
  }
  C ← { 𝕊a: s MR a Pow d }  # Is composite
  0 {𝕨<⟜≠◶⟨1,C∘⊑◶⟨+⟜1⊸𝕊,0⟩⟩𝕩} Witnesses 𝕩
}

witnesses ← { (1↓𝕨)⊸⍋⌾< ⊑ 𝕩˙ }˝ ⍉∘‿2⥊ ⟨
  0                , ⟨1948244569546278⟩
  212321           , 15‿5511855321103177
  624732421        , 15‿7363882082‿992620450144556
  273919523041     , 2‿2570940‿211991001‿3749873356
  47636622961201   , 2‿2570940‿880937‿610386380‿4130785767
  3770579582154547 , 2‿325‿9375‿28178‿450775‿9780504‿1795265022
⟩

# Number of primes less than or equal to 𝕩
Pi ← ((0=≡) ⊑∘⊢⍟⊣ {𝕩 LargePi∘⊣¨⌾((next<𝕩)⊸/) primes⍋𝕩}⌾⥊)∘⌊⚇1
LargePi ← {
  # Meissel-Lehmer algorithm
  Extend 2×√𝕩  # Need one past √𝕩
  a‿b‿c ← primes ⍋ 4‿2‿3 √ 𝕩

  ph ← -´ +´¨ 2⌊∘÷˜1+ (↓⥊𝕩) (⊢∾⟜(0⊸<⊸/)¨·⌽⌊∘÷˜)´ 1↓a↑primes  # φ(𝕩,a)

  p ← a↓b↑primes
  w ← 𝕩 ÷ p
  v ← w ↑˜ ca←c-a
  j ← (primes ⍋ √v) - a+↕ca
  r ← +´Pi w ∾ (j/v)÷(⊒⊸+/j)⊏p
  is ← (b+a-2) × (b¬a) ÷ 2
  js ← +´ j × (a+↕≠j)+(j-1)÷2
  ph + is + js - r
}

NthPrime ← {primes≠⊸≤◶⟨⊑˜,NP⟩𝕩}⚇0
NP ← {
  a ← 2⌈⌈ (1-˜⋆⁼⍟2(++-⟜2⊸÷)⋆⁼)⊸× 𝕩 # Approximation
  d ← 𝕩 - Pi a-1                   # Primes remaining
  p ← ⋆⁼a                          # Number→distance multiplier
  e ← 8××d-0.5                     # Go a few primes further
  a { 𝕩 (≥⟜-∧<)⟜≠◶⟨n𝕊⊣-×⊸×⟜≠,⊑⟩ PrimesIn ∧𝕨⋈n←𝕨+⌊p×𝕩+e } d
}

# Prime factors and exponents
FactorExponents ← {
  CheckNat 𝕩
  2⊸⌊◶⟨!∘"Can't factor 0", 2‿0⊸⥊, IsPrime◶⟨FactorTrial, ≍˘⋈⟜1⟩⟩ 𝕩
}⚇0
FactorTrial ← { 𝕊n:
  r ← 0‿2⥊0  # Transposed result
  Div ← {𝕊p: # Add exponents of p to result
    D←0=p|⊢
    e←0 ⋄ n↩{e+↩1⋄𝕊⍟D𝕩÷p}n
    r∾↩p‿e
  }
  Try ← {
    𝕩 ⌊↩ 1+⌊√n
    𝕨<𝕩 ?
    Div¨ (0=|⟜n)⊸/ PrimesIn 𝕨‿𝕩
    {r∾↩⍉PollardFactors n⋄n↩1⋄𝕩}⍟¬ 𝕩<pollardThreshold ?
    𝕩 𝕊 2×𝕩
  ;@}
  2 Try 64
  ⍉ r ∾ (1<n)/≍n‿1
}

# Pollard's rho algorithm
# https://maths-people.anu.edu.au/~brent/pub/pub051.html
pollardThreshold ← 2⋆16
_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}
GCD ← {𝕨(|𝕊⍟(>⟜0)⊣)𝕩}
# Return a divisor of n other than 1. Can be n if the algorithm fails.
# c should be in ↕n but not 0 or n-2.
PollardRho ← { c 𝕊 n:
  x←ys←y ← 2
  q ← 1
  Mul ← n _modMul
  Adv ← {n-˜⍟≤c+Mul˜𝕩}
  NextY ← {𝕤⋄ |x-(y Adv↩)}
  g ← { 𝕊 r:
    x ↩ y
    y Adv⍟r↩
    k ← 0
    m ← 100  # Check GCD to see if we can stop every m iterations
    FindG ← {𝕤
      k0 ← k
      k ↩ r ⌊ k+m
      ys ↩ y
      q Mul⟜NextY⍟(k-k0)↩
      n GCD q
    } _while_ {k<r? 1=𝕩; 0}
    𝕊∘(r×2)⍟(1⊸=) FindG 1
  } 1
  y ↩ ys  # Backtrack if n=g
  (n GCD NextY)_while_(1⊸=)∘1⍟(n⊸=) g
}
Exps ← (/≠⟜«)⊸(⊏ ≍ -⟜(¯1⊸»)∘⊣)∘∧  # Exponents from list of factors
PollardFactors ← Exps ∘ { 𝕊 n:
  pollardThreshold<n ? ¬IsPrime n ?
  g←n ⋄ 1⊸+ _while_ {n=g↩𝕩 PollardRho n} 1
  g ∾○𝕊 n÷g
; ≍𝕩
}

# Prime factors with repetition
Factor ← /˜˝∘FactorExponents⚇0

# Numbers of prime factors (with multiplicity) for ↕𝕩
FactorCounts ← {
  ¯1⌾⊑ 0 𝕩{𝕗⥊0(1+⌾⊑⊢⌜)⍟(⌊𝕩⋆⁼𝕗)˜↕𝕩}⊸+´ PrimesTo 𝕩
}

# Euler's Totient function
Totient ← (×´ (-⟜1 × ⊣⋆⊢-1˙)˝)∘FactorExponents⚇0
