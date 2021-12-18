weapon(dagger, 8, 4, 0).
weapon(shortsword, 10, 5, 0).
weapon(warhammer, 25, 6, 0).
weapon(longsword, 40, 7, 0).
weapon(greataxe, 74, 8, 0).

armor(none, 0, 0, 0).
armor(leather, 13, 0, 1).
armor(chainmail, 31, 0, 2).
armor(splintmail, 53, 0, 3).
armor(bandedmail, 75, 0, 4).
armor(platemail, 102, 0, 5).

ring(none, 0, 0, 0).
ring(damage_plus1, 25, 1, 0).
ring(damage_plus2, 50, 2, 0).
ring(damage_plus3, 100, 3, 0).
ring(defense_plus1, 20, 0, 1).
ring(defense_plus2, 40, 0, 2).
ring(defense_plus3, 80, 0, 3).

boss_stats(103, 9, 2).

player_stats(Cost, 100, Damage, Armor) :-
    weapon(_, WC, WD, WA),
    armor(_, AC, AD, AA),
    ring(R1, R1C, R1D, R1A),
    ring(R2, R2C, R2D, R2A),
    % Rings must either be distinct or both none
    (R1 \= R2; R1 = none),
    Cost is WC + AC + R1C + R2C,
    Damage is WD + AD + R1D + R2D,
    Armor is WA + AA + R1A + R2A.

turns_to_kill(HitPoints, NetDamage, TurnsToKill) :-
    TurnsToKill is (HitPoints + (NetDamage - 1)) div NetDamage.

wins(Winner, PlayerHitPoints, PlayerNetDamage, BossHitPoints, BossNetDamage) :-
    turns_to_kill(BossHitPoints, PlayerNetDamage, PlayerTurnsToKillBoss),
    turns_to_kill(PlayerHitPoints, BossNetDamage, BossTurnsToKillPlayer),
    (
        (Winner = player, PlayerTurnsToKillBoss =< BossTurnsToKillPlayer)
    ;   (Winner = boss,   BossTurnsToKillPlayer <  PlayerTurnsToKillBoss)
    ).

wins_spending(Winner, Cost) :-
    player_stats(Cost, PlayerHitPoints, PlayerDamage, PlayerArmor),
    boss_stats(BossHitPoints, BossDamage, BossArmor),
    PlayerNetDamage is max(1, PlayerDamage - BossArmor),
    BossNetDamage is max(1, BossDamage - PlayerArmor),
    wins(Winner, PlayerHitPoints, PlayerNetDamage, BossHitPoints, BossNetDamage).

part1_answer(N) :-
    aggregate_all(min(X), wins_spending(player, X), N).

part2_answer(N) :-
    aggregate_all(max(X), wins_spending(boss, X), N).