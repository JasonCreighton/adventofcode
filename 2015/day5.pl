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

part1_nice(Str) :-
    string_chars(Str, CharList),
    chars_num_vowels(CharList, NumVowels),
    NumVowels >= 3,
    doubled_letters(CharList),
    forbidden(CharList, IsForbidden),
    IsForbidden is 0.

matching_pairs(Str) :-
    sub_string(Str, PairIdx1, 2, _, Pair),
    sub_string(Str, PairIdx2, 2, _, Pair),
    PairIdx2 >= (PairIdx1 + 2).

repeats_with_letter_between([X,_,X|_]).
repeats_with_letter_between([_|XS]) :- repeats_with_letter_between(XS).

part2_nice(Str) :-
    string_chars(Str, CharList),
    repeats_with_letter_between(CharList),
    matching_pairs(Str).

part1_answer(N) :-
    puzzle_input(Words),
    include(part1_nice, Words, NiceWords),
    length(NiceWords, N).

part2_answer(N) :-
    puzzle_input(Words),
    include(part2_nice, Words, NiceWords),
    length(NiceWords, N).    