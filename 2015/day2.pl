file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

read_package_dim :-
    retractall(package_dim(_,_,_)),    
    file_lines("inputs/day2.txt", Lines),
    member(Line, Lines),
    split_string(Line, "x", "", [LS, WS, HS]),
    number_string(L, LS),
    number_string(W, WS),
    number_string(H, HS),
    assert(package_dim(L,W,H)).

paper_needed(L, W, H, A) :-
    A1 is L*W,
    A2 is W*H,
    A3 is H*L,
    min_list([A1, A2, A3], ASmallest),
    A is (2*A1) + (2*A2) + (2*A3) + ASmallest.

paper_needed(A) :-
    package_dim(L, W, H),
    paper_needed(L, W, H, A).

ribbon_needed(L, W, H, Ribbon) :-
    P1 is 2 * (L + W),
    P2 is 2 * (W + H),
    P3 is 2 * (H + L),
    Volume is L * W * H,
    min_list([P1, P2, P3], PSmallest),
    Ribbon is PSmallest + Volume.

ribbon_needed(Ribbon) :-
    package_dim(L, W, H),
    ribbon_needed(L, W, H, Ribbon).

part1_answer(N) :-
    findall(_, read_package_dim, _),
    findall(Area, paper_needed(Area), PaperAreaList),
    sum_list(PaperAreaList, N).

part2_answer(N) :-
    findall(_, read_package_dim, _),
    findall(X, ribbon_needed(X), RibbonList),
    sum_list(RibbonList, N).