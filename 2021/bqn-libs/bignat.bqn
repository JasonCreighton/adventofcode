# Arithmetic on large natural numbers.

base ← ⊑ •args ∾ 2⋆52
! 1=•Type base ⋄ ! (⌊⊸=∧2⊸≤) base
l2b ← (base=2⊸⋆)⊸× ⌊2⋆⁼base  # 0 if not a power of two
! (⌈∘√⊸×⍟(0=l2b) base) ≤ 2⋆53

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

Valid ⇐ {
  1==𝕩? ∧´1=•Type¨𝕩? ∧´(⌊⊸=∧0⊸≤∧<⟜base)𝕩? # List of integers in [0,base)
  (0<≠)◶⟨1,0≠⊢´⟩𝕩? 1 ;                    # Highest-order one isn't 0
  0
}
Trim ← { 𝕩 ↑˜ -⟜1 _while_ (≥◶⟨0,0=-⊑𝕩˙⟩⟜1) ≠𝕩 }

_compare ⇐ {
  Full ← 0⊸≤◶⟨𝔽˜,⊑⟜𝕨𝔽⊑⟜𝕩⟩ · -⟜1 _while_ (0⊸≤◶⟨0,⊑⟜𝕨=⊑⟜𝕩⟩) -⟜1
  𝕨 =◶𝔽‿Full○≠ 𝕩
}

Neg ⇐ (!0=≠)⊸⊢
Signum ⇐ ×∘≠
Abs ⇐ Conj ⇐ ⊢

Carry ← {
  b ← 𝕨 ⊣ 0           # Carry in
  g ← 𝕩 ≥ base        # Generate
  p ← 𝕩 = base-1      # Propagate
  i ← ⌈`∘×⟜(1+↕∘≠)¬p  # Start index of propagation chain
  a ← i ⊏ gs←b∾g      # Active propagations
  c ← g ∨ p ∧ a       # Carry from these positions
  r ← (𝕩 + b»c) - c×base
  ⟨r, c⊸«⌾⋈b⟩
}
_extend ← { 𝕨 𝔽○((𝕨⌈○≠𝕩)⊸↑) 𝕩 }
Add ⇐ {
  𝕨𝕊⁼𝕩: 𝕩Sub𝕨; 𝕨𝕊˜⁼𝕩: 𝕩Sub𝕨;
  0⊸<◶⊣‿∾´ Carry 𝕨 +_extend 𝕩
}
Sub ⇐ {
  ! 𝕨 ≥○≠ 𝕩
  s‿c ← 1 Carry 𝕨 (⊣ + (base-1)-⊢)_extend 𝕩
  ! 1 = c
  Trim s
}

Mul ⇐ {
  512 < n←𝕨⌊○≠𝕩 ? # Karatsuba
    k←⌊n÷2
    # Add⟜((k⥊0)⊸∾){𝔽´𝔽¨˝} 𝕨 𝕊⌜○(k⊸(↑⋈↓)) 𝕩  but one less 𝕊
    l‿h‿a ← 𝕨 𝕊¨○(∾⟜(<Add´)k⊸(↑⋈↓)) 𝕩
    Add⟜((k⥊0)⊸∾)´ ⟨l, a Sub l Add h, h⟩
  ;
  0 = 𝕨⌊○≠𝕩 ? ↕0 ;
  _mso ← { q←𝕗
    s←o ← 0¨𝕩                          # Sum, overflow (maintain ∧´s<q)
    p ← {c←q≤a←𝕩+«s ⋄ s↩a-c×q ⋄ o↩c+«o ⋄ ⊑¨s‿o}∘×⟜𝕩¨ 𝕨
    (<˘⍉¯1↓>p) ∾¨ s‿o                  # Restore passed sums
  }
  Bb ← Add⟜(0⊸∾)´
  _sp ← {t←⌊𝕩÷𝕗 ⋄ ⟨𝕩-𝕗×t, t⟩}          # Split into top and bottom
  Sb ← base _sp
  M ← {
    (q ← ×˜base) ≤ 2⋆53 ?
    s‿o ← 𝕨 q _mso 𝕩
    Bb (Sb s) ∾ {∧´𝕩<base?⋈𝕩; <⊸∾⟜𝕊´Sb𝕩} o
  ;
    s ← ⌈√base  # Can represent one limb with two base s, but b>×˜s-1
    m ← 𝕨 (Bb base _mso)⌜○(s _sp) 𝕩    # Result is +´⥊(×⌜˜1‿s)×m
    p ← { 0<l2b ? Add¨⟜(0⊸∾⌾⊑⌽)˝m ; Add´¨(+⌜˜↕2)⊔m }
    Add⟜{Bb Sb s×𝕩}´ p
  }
  Trim 𝕨M𝕩
}

Log2f ← {-⟜(𝕩<2⋆⊢)⌊0.5+2⋆⁼𝕩} # Exact ⌊2⋆⁼𝕩
L2s ← {(√2)⊸≤◶⟨⋈,{⟨1+𝕨,𝕩÷2⟩}⟩⟜(𝕩÷2⊸⋆) ⌊(÷4)+2⋆⁼𝕩} # Split 𝕩=m×2⋆p, 0.5>|⋆⁼m
Mant ← +⟜(÷⟜base)´∘⌽ (-⌈53÷2⋆⁼base)⊸↑
Log2long ← {
  LD ← (2⋆⁼⊢)⌾(1⊸⊑) L2s
  +´ (LD Mant 𝕩) + (1-˜≠𝕩) × {0≠l2b? l2b‿0 ; LD base}
}
Log ⇐ {
  (≠𝕩)≤53 ? (base⋆≠𝕩) ≤ 2⋆53 ? 𝕨 ⋆⁼ ToNum 𝕩 ;
  𝕨 {2𝕊𝕩:𝕩; (𝕨⋆⁼2)×𝕩} Log2long 𝕩
}
Log2 ⇐ 2⊸Log

DivMod ⇐ {
  𝕨 <_compare 𝕩 ? ⟨↕0, 𝕨⟩ ;
  "Non power-of-2 bases not yet implemented" ! 0≠l←l2b
  Mu ← (From 2⋆l|⊣)⊸Mul
  M2 ← (⌊∘÷⟜l⥊0˙) ∾ Mu                 #  𝕩×2⋆𝕨
  D2 ← ⌈∘÷⟜l (↑⟨1⟩⊸Add⍟(∨´≠⟜0)↓) -⊸Mu  # ⌊𝕩÷2⋆𝕨
  Recip ← { # approximate (2⋆𝕨-b)÷m given b‿m←𝕩, (2⋆b-1)≤m<2⋆b
    𝕨≤2 ? From ⌊3×2⋆𝕨-1 ;
    z ← (h←1+⌊𝕨÷2) 𝕊 𝕩
    xp ← -⟜(𝕨+2)⊸D2´ 𝕩
    (z M2˜ 𝕨¬h) Sub (h+h+2) D2 xp Mul z Mul z  # Newton
  }
  Log ← (Log2f⊢´) + l×≠-1˙             # ⌊2⋆⁼𝕩
  n‿m ← 1+Log¨ 𝕨‿𝕩
  p ← (n¬m) Recip m‿𝕩
  r ← 𝕩 Mul q ← (n+1) D2 p Mul 𝕨       # Approximate quotient
  o ← 𝕨 ≥_compare⟜r{𝔽◶⟨¯1, 𝔽 Sub⟩} 𝕩   # Required correction
  C ← Add⍟o
  ⟨(⋈1) C q, 𝕨 Sub 𝕩 C r⟩
}
Div ⇐ ⊑ DivMod

Pow ⇐ Mul {F _𝕣: {
  ⟨i⟩𝕊𝕩:i≤1? 𝕨 ;
  r←⟨1⟩⋄U←{U↩F⋄𝕨}  # Skip first multiply, where 𝕩 will be ⟨1⟩
  𝕨 {r𝕨⊸U⍟(2|𝕩)↩⋄𝕩>1?𝕨F˜⊸𝕊⌊𝕩÷2;r} ToNum⍟= 𝕩
}}

Fact ⇐ { 𝕩≤1? ⟨1⟩; 𝕨𝕊n:
  Prod ← {2≤l←≠𝕩 ? (⌊l÷2)(↑Mul○𝕊↓)𝕩 ; From ×´𝕩} # Recurse to keep intermediates small
  Pri ← {/(2≤↕𝕩){𝕩>0⌾(𝕨⊸⊑)𝕩≠⊸⥊𝕨↑1}⍟⊑´⌽↕⌈√𝕩}     # Primes <𝕩
  p ← 𝕨 Pri⊘(≤/⊣) n+1                           # (save them in 𝕨)
  s ← Prod 1⊸<⊸/ {𝕊p:p⋆+´2|{𝕊0:↕0;𝕊⊸∾⌊𝕩÷p}n}¨ p # Swinging factorial
  s Mul Mul˜ p 𝕊 ⌊n÷2
}∘⊢

FromSmall ← {𝕩<base? ⟨𝕩⟩; d∾𝕊base÷˜𝕩-d←base|𝕩}
From ⇐ {
  𝕊⁼𝕩: ! Valid 𝕩 ⋄ ToNum 𝕩 ;
  ! 1 = •Type 𝕩
  ! (0≤𝕩) ∧ 𝕩<∞
  ! ⌊⊸=𝕩
  𝕩>𝕩-1 ? 0⊸<◶↕‿FromSmall 𝕩 ;  # any a<𝕩 is an exact float
  # 𝕩 = mf×2⋆p, where ⌽e is the binary expansion of p
  e‿mf ← 2 {(1⌈⌊)⊸=𝕩÷𝕨? e‿m←(×˜𝕨)𝕊𝕩 ⋄ a←⌊⊸=r←m÷𝕨 ⋄ ⟨e∾a,r⍟a m⟩; ⟨↕0,𝕩⟩} 𝕩
  m ← FromSmall mf
  {
    0≠l←l2b ? p←+˜⊸+˜´⌽e ⋄ (0⥊˜p⌊∘÷l) ∾ ⟨2⋆l|p⟩ Mul m ;
    m Mul´ Mul˜⍟(/⌾⌽e) ⟨2⟩  # do smaller multiplies first
  }
}
ToNum ⇐ 0 { r←𝕨+base×𝕩 ⋄ "inexact"!𝕨=base|r ⋄ r }´ ⊢
NearestNum ⇐ {
  (base⋆≠𝕩) ≤ 2⋆53 ? 0 +⟜(base⊸×)´ 𝕩 ;
  0≠l←l2b ?
  b ← ¯53 + Log2f ⊢´𝕩
  r ← 2⋆l|b ⋄ d ← (≠𝕩) + 1-˜⌊b÷l
  (2⋆l×d) × +⟜(base⊸×)´ (0¨⊸≢d↑𝕩˙)⊸+⌾⊑⍟(r=(2×r)|⊑) d↓𝕩
; ! "Non power-of-2 bases not yet implemented"
}
