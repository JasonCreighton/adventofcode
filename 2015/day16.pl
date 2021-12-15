:- dynamic sue/2.

read_file(File, Str) :-
    setup_call_cleanup(
        open(File, read, In),
        read_string(In, _, Str),
        close(In)).

load_facts :-
    retractall(sue(_, _)),
    read_file("inputs/day16.txt", Str),
    split_string(Str, "\n", "", Lines),
    member(Line, Lines),
    split_string(Line, " ", ":,", Words),
    maplist(atom_string, Atoms, Words),
    process_line(Atoms).

attributes_dict([], _{}).
attributes_dict([K,V|Rest], Dict) :-
    attributes_dict(Rest, RestDict),
    atom_number(V, N),
    Dict = RestDict.put(K,N).

process_line(['Sue', NAtom|Attributes]) :-
    attributes_dict(Attributes, AttrDict),
    atom_number(NAtom, N),
    assert(sue(N, AttrDict)).

sue_matching(N, SelectDict) :-
    sue(N, SueDict),
    SelectDict >:< SueDict.

part1_answer(N) :-
    sue_matching(N, _{
        children: 3,
        cats: 7,
        samoyeds: 2,
        pomeranians: 3,
        akitas: 0,
        vizslas: 0,
        goldfish: 5,
        trees: 3,
        cars: 2,
        perfumes: 1
    }).

:- forall(load_facts, true).