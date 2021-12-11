file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

line_parts_rect([SX1, SY1, _, SX2, SY2], rect(X1, Y1, X2, Y2)) :-
    number_string(X1, SX1),
    number_string(Y1, SY1),
    number_string(X2, SX2),
    number_string(Y2, SY2).

line_parts_command(["toggle"|Rest], cmd(toggle, Rect)) :- line_parts_rect(Rest, Rect).
line_parts_command(["turn", "on"|Rest], cmd(on, Rect)) :- line_parts_rect(Rest, Rect).
line_parts_command(["turn", "off"|Rest], cmd(off, Rect)) :- line_parts_rect(Rest, Rect).

line_command(Line, Command) :-
    split_string(Line, ", ", "", LineParts),
    line_parts_command(LineParts, Command).

puzzle_input(Commands) :-
    file_lines("inputs/day6.txt", Lines),
    maplist(line_command, Lines, Commands).

inside(rect(X1, Y1, X2, Y2), point(PX, PY)) :-
    PX >= X1,
    PX =< X2,
    PY >= Y1,
    PY =< Y2.

operation_states(toggle, 0, 1).
operation_states(toggle, 1, 0).
operation_states(on, _, 1).
operation_states(off, _, 0).

rect_point_operation_states(Rect, Point, Op, Prev, Next) :-
    (
        inside(Rect, Point)
    ->  operation_states(Op, Prev, Next)
    ;   Next = Prev
    ).

commands_states([], _, Final, Final).
commands_states([cmd(Op, Rect)|Cmds], Point, Prev, Final) :-
    rect_point_operation_states(Rect, Point, Op, Prev, Next),
    commands_states(Cmds, Point, Next, Final).

final_light_state(CmdList, Point, Final) :-
    commands_states(CmdList, Point, 0, Final).

all_final_light_states(CmdList, Final) :-
    between(0, 999, X),
    format("X: ~d\n", [X]),
    between(0, 999, Y),
    final_light_state(CmdList, point(X, Y), Final).

part1_answer(N) :-
    puzzle_input(CmdList),
    aggregate_all(sum(X), all_final_light_states(CmdList, X), N).