:- dynamic happiness/3.

read_file(File, Str) :-
    setup_call_cleanup(
        open(File, read, In),
        read_string(In, _, Str),
        close(In)).

load_facts :-
    retractall(happiness(_, _, _)),
    read_file("inputs/day13.txt", Str),
    split_string(Str, "\n", ".", Lines),
    member(Line, Lines),
    string_lower(Line, LowerLine),
    split_string(LowerLine, " ", "", Words),
    maplist(atom_string, Atoms, Words),
    process_line(Atoms).

process_line([PersonA, would, GainOrLose, NAtom, happiness, units, by, sitting, next, to, PersonB]) :-
    atom_number(NAtom, N),
    (
        (GainOrLose = gain, AdjN = N)
    ;   (GainOrLose = lose, AdjN is -N)
    ),
    assert(happiness(PersonA, PersonB, AdjN)).

net_happiness(A, B, N) :-
    happiness(A, B, ADelta),
    happiness(B, A, BDelta),
    N is ADelta + BDelta.
net_happiness(self, _, 0).
net_happiness(_, self, 0).

seating(S) :-
    permutation([alice, bob, carol, david, eric, frank, george, mallory], S).

part2_seating(S) :-
    permutation([self, alice, bob, carol, david, eric, frank, george, mallory], S).

seating_happiness([A], Happiness, Z) :- net_happiness(A, Z, Happiness).
seating_happiness([A,B|Rest], Happiness, Z) :-
    net_happiness(A, B, ABHappiness),
    seating_happiness([B|Rest], RestHappiness, Z),
    Happiness is ABHappiness + RestHappiness.

seating_happiness([First|Rest], Happiness) :- seating_happiness([First|Rest], Happiness, First).

part1_answer(N) :-
    aggregate_all(max(H), (seating(S), seating_happiness(S, H)), N).

part2_answer(N) :-
    aggregate_all(max(H), (part2_seating(S), seating_happiness(S, H)), N).


:- forall(load_facts, true).