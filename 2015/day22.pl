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

turn(gamestate(player, PlayerHitPoints, PlayerMana, BossHitPoints, SpellHistory),
     gamestate(boss, NewPlayerHitPoints, NewPlayerMana, NewBossHitPoints, [Spell|SpellHistory])) :-
    spell(Spell, SpellManaCost, SpellDamage, SpellHealing),
    active_effects_sum(SpellHistory, _, EffectDamage, EffectMana),
    NewPlayerHitPoints is PlayerHitPoints + SpellHealing,
    NewPlayerMana is PlayerMana - SpellManaCost + EffectMana,
    NewPlayerMana >= 0,
    NewBossHitPoints is BossHitPoints - SpellDamage - EffectDamage.

turn(gamestate(boss, PlayerHitPoints, PlayerMana, BossHitPoints, SpellHistory),
     gamestate(player, NewPlayerHitPoints, NewPlayerMana, NewBossHitPoints, [bossattack|SpellHistory])) :-
    boss_stats(_, BossDamage),
    active_effects_sum(SpellHistory, EffectArmor, EffectDamage, EffectMana),
    NewPlayerHitPoints is PlayerHitPoints - max(1, BossDamage - EffectArmor),
    NewPlayerMana is PlayerMana + EffectMana,
    NewBossHitPoints is BossHitPoints - EffectDamage.

in_progress(gamestate(_, PHP, _, BHP, _)) :- PHP >= 0, BHP >= 0.

winner(player, gamestate(_, _, _, BHP, _)) :- BHP < 0.
winner(boss, gamestate(_, PHP, _, BHP, _)) :- BHP >= 0, PHP < 0.

eventual_winner(Winner, State, FinalState) :-
    (
        in_progress(State)
    ->  (
            turn(State, NextState),
            eventual_winner(Winner, NextState, FinalState)
        )
    ;   winner(Winner, State)
    ).