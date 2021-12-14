:- use_module(library(clpfd)).

puzzle_input(CharList) :-
    string_chars("hxbxwxba", CharList).

number_base26(N, Base26) :-
    UpperLimit #= ((26 ^ 8) - 1),
    N in 0 .. UpperLimit,
    D7 #= ((N div (26^7)) mod 26),
    D6 #= ((N div (26^6)) mod 26),
    D5 #= ((N div (26^5)) mod 26),
    D4 #= ((N div (26^4)) mod 26),
    D3 #= ((N div (26^3)) mod 26),
    D2 #= ((N div (26^2)) mod 26),
    D1 #= ((N div (26^1)) mod 26),
    D0 #= ((N div (26^0)) mod 26),
    Base26 = [D7, D6, D5, D4, D3, D2, D1, D0].

char_digit26(Char, Digit) :-
    char_code(a, Code_a),
    Code #= Code_a + Digit,
    char_code(Char, Code).

number_password(N, CharList) :-
    number_base26(N, Base26),
    maplist(char_digit26, CharList, Base26).

straight_of_three([A,B,C|Rest]) :-
    (B #= A + 1, C #= B + 1); straight_of_three([B,C|Rest]).

num_pairs([], 0).
num_pairs([_], 0).
num_pairs([X,X|Rest], N) :-
    num_pairs(Rest, RestN),
    N #= RestN + 1.
num_pairs([X,Y|Rest], N) :-
    X \= Y,
    num_pairs([Y|Rest], N).

only_allowed_letters([]).
only_allowed_letters([X|XS]) :-
    char_code(a, Code_a),
    Code_X #= Code_a + X,
    char_code(Char, Code_X),
    Char \= i,
    Char \= o,
    Char \= l,
    only_allowed_letters(XS).

base26_password_allowed(Base26) :-
    only_allowed_letters(Base26),
    straight_of_three(Base26),
    num_pairs(Base26, NumPairs),
    NumPairs #>= 2.

all_base26(StartBase26, Base26) :- Base26 = StartBase26.
all_base26(StartBase26, Base26) :-
    base26_increment(StartBase26, NextBase26, _),
    all_base26(NextBase26, Base26).

part1_2_answers(Password) :-
    puzzle_input(InitialPassword),
    number_password(InitialN, InitialPassword),
    number_base26(InitialN, InitialBase26),
    all_base26(InitialBase26, TryBase26),
    base26_password_allowed(TryBase26),
    number_base26(N, TryBase26),
    number_password(N, Password).