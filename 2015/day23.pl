:- dynamic instruction/2.

read_file(File, Str) :-
    setup_call_cleanup(
        open(File, read, In),
        read_string(In, _, Str),
        close(In)).

load_facts :-
    retractall(instruction(_, _)),
    read_file("inputs/day23.txt", Str),
    split_string(Str, "\n", "", Lines),
    nth0(InstIdx, Lines, Line),
    split_string(Line, " ", ",", Words),
    maplist(atom_string, Atoms, Words),    
    process_line(InstIdx, Atoms).

process_line(I, [hlf, Reg]) :- assert(instruction(I, hlf(Reg))).
process_line(I, [tpl, Reg]) :- assert(instruction(I, tpl(Reg))).
process_line(I, [inc, Reg]) :- assert(instruction(I, inc(Reg))).
process_line(I, [jmp, Offset]) :- atom_number(Offset, OffsetNum), assert(instruction(I, jmp(OffsetNum))).
process_line(I, [jie, Reg, Offset]) :- atom_number(Offset, OffsetNum), assert(instruction(I, jie(Reg, OffsetNum))).
process_line(I, [jio, Reg, Offset]) :- atom_number(Offset, OffsetNum), assert(instruction(I, jio(Reg, OffsetNum))).

reg(cpu(_, A, _), a, A).
reg(cpu(_, _, B), b, B).
update_reg(cpu(IP, _, B), cpu(IP, NewA, B), a, NewA).
update_reg(cpu(IP, A, _), cpu(IP, A, NewB), b, NewB).

adj_ip(Offset, cpu(IP, A, B), cpu(NewIP, A, B)) :- NewIP is IP + Offset.
hlf(Old, New) :- New is Old div 2.
tpl(Old, New) :- New is Old * 3.
inc(Old, New) :- New is Old + 1.
jie(Val) :- R is Val mod 2, R is 0.
jio(1).

alu_instruction_step(OpPred, Reg, State0, State) :-
    reg(State0, Reg, Val),
    call(OpPred, Val, NewVal),
    update_reg(State0, State1, Reg, NewVal),
    adj_ip(1, State1, State).

cond_jump(CondPred, Reg, Offset, State0, State) :-
    reg(State0, Reg, Val),
    (
        call(CondPred, Val)
    ->  CondOffset is Offset
    ;   CondOffset is 1
    ),
    adj_ip(CondOffset, State0, State).

instruction_step(hlf(Reg), State0, State) :- alu_instruction_step(hlf, Reg, State0, State).
instruction_step(tpl(Reg), State0, State) :- alu_instruction_step(tpl, Reg, State0, State).
instruction_step(inc(Reg), State0, State) :- alu_instruction_step(inc, Reg, State0, State).
instruction_step(jmp(Offset), State0, State) :- adj_ip(Offset, State0, State).
instruction_step(jie(Reg, Offset), State0, State) :- cond_jump(jie, Reg, Offset, State0, State).
instruction_step(jio(Reg, Offset), State0, State) :- cond_jump(jio, Reg, Offset, State0, State).

step(OldState, NewState) :-
    cpu(IP, _, _) = OldState,
    instruction(IP, Inst),
    instruction_step(Inst, OldState, NewState).

run_to_completion(State0, State) :-
    (
        step(State0, State1)
    ->  run_to_completion(State1, State)
    ;   State = State0
    ).

part1_answer(N) :- run_to_completion(cpu(0, 0, 0), cpu(_, _, N)).
part2_answer(N) :- run_to_completion(cpu(0, 1, 0), cpu(_, _, N)).

:- forall(load_facts, true).