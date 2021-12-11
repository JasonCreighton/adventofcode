puzzle_input("iwrupvqb").

advent_coin(Key, HashPrefix, N) :-
    between(1, inf, N),
    number_string(N, NStr),
    string_concat(Key, NStr, HashInput),
    md5_hash(HashInput, Hash, [encoding(octet)]),
    sub_atom(Hash, 0, _, _, HashPrefix).

part1_answer(N) :-
    puzzle_input(Key),
    advent_coin(Key, '00000', N).

part2_answer(N) :-
    puzzle_input(Key),
    advent_coin(Key, '000000', N).