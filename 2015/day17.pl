puzzle_input([43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38]).

list_total_ways([], 0, 1).
list_total_ways([], Total, 0) :- Total \= 0.
list_total_ways([X|XS], Total, Ways) :-
    TotalMinusX is Total - X,
    list_total_ways(XS, TotalMinusX, WaysWithX),
    list_total_ways(XS, Total, WaysWithoutX),
    Ways is WaysWithX + WaysWithoutX.

part1_answer(N) :-
    puzzle_input(Input),
    list_total_ways(Input, 150, N).