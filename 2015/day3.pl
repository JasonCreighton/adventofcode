file_contents(File, Str) :-
    setup_call_cleanup(open(File, read, In),
       read_string(In, _, Str),
       close(In)).

puzzle_input(Dirs) :-
    file_contents("inputs/day3.txt", Str),
    string_chars(Str, Dirs).

direction_delta('<', [-1, 0]).
direction_delta('>', [1, 0]).
direction_delta('^', [0, 1]).
direction_delta('v', [0, -1]).

directions_positions([], [], _).
directions_positions([D|DS], [P|PS], [PrevX, PrevY]) :-
    direction_delta(D, [DeltaX, DeltaY]),
    NewX is PrevX + DeltaX,
    NewY is PrevY + DeltaY,
    P = [NewX, NewY],
    directions_positions(DS, PS, P).

part1_answer(N) :-
    puzzle_input(Dirs),
    directions_positions(Dirs, PositionsWithoutStart, [0,0]),
    Positions = [[0,0]|PositionsWithoutStart],
    sort(Positions, UniquePositions),
    length(UniquePositions, N).