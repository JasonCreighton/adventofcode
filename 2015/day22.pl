% spell(Name, ManaCost, Damage, Healing)
spell(magicmissile, 53, 4, 0).
spell(drain, 73, 2, 2).
spell(shield, 113, 0, 0).
spell(poison, 173, 0, 0).
spell(recharge, 229, 0, 0).

% effect(SpellName, Turns, Armor, Damage, Mana)
effect(shield, 6, 7, 0, 0).
effect(poison, 6, 0, 3, 0).
effect(recharge, 5, 0, 0, 101).

% boss_stats(HitPoints, Damage)
boss_stats(55, 8).

% player_stats(HitPoints, StartingMana)
player_stats(50, 500).

effect_active(Spell, SpellHistory) :-
    effect(Spell, TurnLimit, _, _, _),
    nth1(TurnsAgo, SpellHistory, Spell),
    TurnsAgo < TurnLimit.

active_effects_sum(SpellHistory, Armor, Damage, Mana) :-
    aggregate_all(x(sum(A), sum(D), sum(M)), (effect(E, _, A, D, M), effect_active(E, SpellHistory)), x(Armor, Damage, Mana)).