puzzle_input(2978, 3083).

first_code(20151125).
next_code(Code, NextCode) :- NextCode is (Code * 252533) mod 33554393.

nth1_code_helper(Code, 1, Code).
nth1_code_helper(Current, N, Final) :-
    N > 1,
    next_code(Current, Next),
    Nm1 is N - 1,
    nth1_code_helper(Next, Nm1, Final).

nth1_code(N, Code) :- first_code(First), nth1_code_helper(First, N, Code).

row_col_n(Row, Col, N) :-
    % Follow the diagonal up and to the right
    ColumnAtEndOfDiag is Row + Col - 1,
    % N on the first row are triangle numbers, which have this closed form solution
    NAtEndOfDiag is (ColumnAtEndOfDiag * (ColumnAtEndOfDiag + 1)) div 2,
    % Back up to the real number of interest
    N is NAtEndOfDiag - (ColumnAtEndOfDiag - Col).

part1_answer(Code) :-
    puzzle_input(Row, Col),
    row_col_n(Row, Col, N),
    nth1_code(N, Code).