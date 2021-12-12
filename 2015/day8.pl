read_file(File, Str) :-
    setup_call_cleanup(
        open(File, read, In),
        read_string(In, _, Str),
        close(In)).

puzzle_input(CharLists) :-
    read_file("inputs/day8.txt", Str),
    split_string(Str, "\n", "", Lines),
    maplist(string_chars, Lines, CharLists).

escape_memory_size(['"'|XS], Size) :- contents_memory_size(XS, RestSize), Size is RestSize + 1.
escape_memory_size(['\\'|XS], Size) :- contents_memory_size(XS, RestSize), Size is RestSize + 1.
escape_memory_size(['x', _, _|XS], Size) :- contents_memory_size(XS, RestSize), Size is RestSize + 1.

contents_memory_size([], 0).
contents_memory_size([X|XS], Size) :-
    (
        X = '\\'
    ->  escape_memory_size(XS, Size)
    ;   (
            contents_memory_size(XS, RestSize),
            Size is RestSize + 1
        )
    ).

string_literal_memory_size(['"'|XS], Size) :-
    contents_memory_size(XS, ContentsSize),
    Size is ContentsSize - 1. % Don't count trailing "

needs_escaping('"').
needs_escaping('\\').

quoted_contents_size([], 0).
quoted_contents_size([X|XS], Size) :-
    (
        needs_escaping(X)
    ->  ThisSize = 2
    ;   ThisSize = 1
    ),
    quoted_contents_size(XS, RestSize),
    Size is ThisSize + RestSize.

quoted_size(Chars, QuotedSize) :-
    quoted_contents_size(Chars, ContentsSize),
    QuotedSize is ContentsSize + 2.    

answers(Part1, Part2) :-
    puzzle_input(CharLists),
    maplist(length, CharLists, StringLiteralSizes),
    maplist(string_literal_memory_size, CharLists, MemorySizes),
    sum_list(StringLiteralSizes, TotalStringLiteralSize),
    sum_list(MemorySizes, TotalMemorySize),
    Part1 is TotalStringLiteralSize - TotalMemorySize,
    
    maplist(quoted_size, CharLists, QuotedSizes),
    sum_list(QuotedSizes, TotalQuotedSize),
    Part2 is TotalQuotedSize - TotalStringLiteralSize.