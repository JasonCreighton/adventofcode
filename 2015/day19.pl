:- dynamic replacement/2.
:- dynamic puzzle_input/1.

read_file(File, Str) :-
    setup_call_cleanup(
        open(File, read, In),
        read_string(In, _, Str),
        close(In)).

load_facts :-
    retractall(replacement(_, _)),
    retractall(puzzle_input(_)),
    read_file("inputs/day19.txt", Str),
    split_string(Str, "\n", "", Lines),
    member(Line, Lines),
    process_line(Line).

string_molecule_list_helper(ReCaptures, Acc, [Molecule|Acc]) :-
    atom_string(Molecule, ReCaptures.0).

string_molecule_list(Str, MoleculeList) :-
    re_foldl(string_molecule_list_helper, "[A-Z][a-z]*", Str, [], RevMoleculeList, []),
    reverse(RevMoleculeList, MoleculeList).

process_line(Line) :-
    re_matchsub("^([A-Za-z]+) => ([A-Za-z]+)$", Line, Captures, []),
    !,
    atom_string(From, Captures.1),
    string_molecule_list(Captures.2, To),
    assert(replacement(From, To)).

process_line(Line) :-
    re_match("^[A-Za-z]+$", Line),
    !,
    string_molecule_list(Line, PuzInput),
    assert(puzzle_input(PuzInput)).

one_step([X|XS], Replacement) :-
    replacement(X, X2),
    append(X2, XS, Replacement).
one_step([X|XS], [X|Replacement]) :- one_step(XS, Replacement).

num_steps(Src, Src, 0).
num_steps(Src, Dest, N) :-
    % Greedy heuristic of selecting smallest resulting list, seems to be needed for practical termination
    aggregate_all(min(Len, X), (one_step(X, Dest), length(X, Len)), min(_, X)),
    num_steps(Src, X, NSrcToX),
    N is NSrcToX + 1.

part1_answer(N) :-
    puzzle_input(Input),
    aggregate(count, X, one_step(Input, X), N).

part2_answer(N) :-
    puzzle_input(Input),
    num_steps([e], Input, N).

:- forall(load_facts, true).