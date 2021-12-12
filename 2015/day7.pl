load_wire_funcs :-
    setup_call_cleanup(
        open("inputs/day7.txt", read, In),
        forall(process_input(In), true),
        close(In)).

process_input(In) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines),
    member(Line, Lines),
    split_string(Line, " ", "", Words),
    maplist(atom_string, Atoms, Words),
    process_line(Atoms).

process_line([X, 'AND', Y, '->', Z]) :- atom_arg(X, AX), atom_arg(Y, AY), assert(wire_func(Z, and(AX, AY))).
process_line([X, 'OR', Y, '->', Z]) :- atom_arg(X, AX), atom_arg(Y, AY), assert(wire_func(Z, or(AX, AY))).
process_line(['NOT', X, '->', Z]) :- atom_arg(X, AX), assert(wire_func(Z, not(AX))).
process_line([X, 'LSHIFT', Y, '->', Z]) :- atom_arg(X, AX), atom_arg(Y, AY), assert(wire_func(Z, lshift(AX, AY))).
process_line([X, 'RSHIFT', Y, '->', Z]) :- atom_arg(X, AX), atom_arg(Y, AY), assert(wire_func(Z, rshift(AX, AY))).
process_line([X, '->', Z]) :- atom_arg(X, AX), assert(wire_func(Z, copy(AX))).

atom_arg(Atom, Arg) :-
    (
        atom_number(Atom, N)
    ->  Arg = const(N)
    ;   Arg = wire(Atom)
    ).

arg_signal(const(Out), Out).
arg_signal(wire(WX), Out) :- wire_signal(WX, Out).

func_signal(copy(AX), Out) :- arg_signal(AX, Out).
func_signal(and(AX, AY), Out) :- arg_signal(AX, X), arg_signal(AY, Y), Out is X /\ Y.
func_signal(or(AX, AY), Out) :- arg_signal(AX, X), arg_signal(AY, Y), Out is X \/ Y.
func_signal(lshift(AX, AY), Out) :- arg_signal(AX, X), arg_signal(AY, Y), Out is X << Y.
func_signal(rshift(AX, AY), Out) :- arg_signal(AX, X), arg_signal(AY, Y), Out is X >> Y.
func_signal(not(AX), Out) :- arg_signal(AX, X), Out is \ X.

% Tabling is required to avoid exponential blowup
:- table wire_signal/2.
wire_signal(WireName, Out) :-
    wire_func(WireName, LogicFunc),
    func_signal(LogicFunc, OutFullPrecision),
    Out is OutFullPrecision /\ 0xFFFF.

:-
    retractall(wire_func(_,_)),
    load_wire_funcs.