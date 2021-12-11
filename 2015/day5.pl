file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

puzzle_input(Lines) :- file_lines("inputs/day5.txt", Lines).

vowel(a).
vowel(e).
vowel(i).
vowel(o).
vowel(u).

chars_num_vowels(CharList, NumVowels) :-
    include(vowel, CharList, VowelList),
    string_length(VowelList, NumVowels).

doubled_letters([X,X|_]).
doubled_letters([_|XS]) :- doubled_letters(XS).

forbidden([a,b|_], 1) :- !.
forbidden([c,d|_], 1) :- !.
forbidden([p,q|_], 1) :- !.
forbidden([x,y|_], 1) :- !.
forbidden([], 0) :- !.
forbidden([_|XS], IsForbidden) :- forbidden(XS, IsForbidden).

nice(Str) :-
    string_chars(Str, CharList),
    chars_num_vowels(CharList, NumVowels),
    NumVowels >= 3,
    doubled_letters(CharList),
    forbidden(CharList, IsForbidden),
    IsForbidden is 0.

part1_answer(N) :-
    puzzle_input(Words),
    include(nice, Words, NiceWords),
    length(NiceWords, N).