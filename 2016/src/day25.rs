use std::collections::HashSet;

use regex::Regex;

const NUM_REGISTERS: usize = 4;

#[derive(Debug, Copy, Clone)]
enum Arg {
    Const(i64),
    Reg(u8),
}

impl Arg {
    fn get(&self, registers: &[i64; NUM_REGISTERS]) -> i64 {
        match self {
            Self::Const(n) => *n,
            Self::Reg(r) => registers[*r as usize],
        }
    }
}

#[derive(Debug, Copy, Clone)]
enum Inst {
    Cpy(Arg, Arg),
    Inc(Arg),
    Dec(Arg),
    Jnz(Arg, Arg),
    Out(Arg),
}

fn register_index(reg: &str) -> Option<u8> {
    match reg {
        "a" => Some(0),
        "b" => Some(1),
        "c" => Some(2),
        "d" => Some(3),
        _ => None,
    }
}

fn parse_arg(op: &str) -> Arg {
    match register_index(op) {
        Some(r) => Arg::Reg(r),
        None => Arg::Const(op.parse().unwrap()),
    }
}

fn parse_instructions(puzzle_input: &str) -> Vec<Inst> {
    let re_cpy = Regex::new(r"^cpy ([abcd]|-?[0-9]+) ([abcd])$").unwrap();
    let re_inc = Regex::new(r"^inc ([abcd])$").unwrap();
    let re_dec = Regex::new(r"^dec ([abcd])$").unwrap();
    let re_jnz = Regex::new(r"^jnz ([abcd]|-?[0-9]+) ([abcd]|-?[0-9]+)$").unwrap();
    let re_out = Regex::new(r"^out ([abcd]|-?[0-9]+)$").unwrap();

    let mut insts = Vec::new();
    for line in puzzle_input.lines() {
        if let Some(captures) = re_cpy.captures(line) {
            insts.push(Inst::Cpy(parse_arg(&captures[1]), parse_arg(&captures[2])));
        } else if let Some(captures) = re_inc.captures(line) {
            insts.push(Inst::Inc(parse_arg(&captures[1])));
        } else if let Some(captures) = re_dec.captures(line) {
            insts.push(Inst::Dec(parse_arg(&captures[1])));
        } else if let Some(captures) = re_jnz.captures(line) {
            insts.push(Inst::Jnz(parse_arg(&captures[1]), parse_arg(&captures[2])));
        } else if let Some(captures) = re_out.captures(line) {
            insts.push(Inst::Out(parse_arg(&captures[1])));            
        } else {
            panic!("Unmatched instruction: '{}'", line);
        }
    }

    insts
}

fn generates_clock(insts: &[Inst], registers: &mut [i64; NUM_REGISTERS]) -> bool {
    let mut ip: usize = 0;
    let mut expected_out: i64 = 0;
    let mut seen_states: HashSet<(usize, [i64; NUM_REGISTERS], i64)> = HashSet::new();

    while ip < insts.len() {
        if seen_states.contains(&(ip, *registers, expected_out)) {
            // We are in a loop, and the check on "out" didn't fail when we
            // were previously in this state, so we succeeded.
            return true;
        }
        seen_states.insert((ip, *registers, expected_out));

        let mut ip_offset: i64 = 1;
        match insts[ip] {
            Inst::Cpy(src, Arg::Reg(dest)) => registers[dest as usize] = src.get(&registers),
            Inst::Inc(Arg::Reg(reg)) => registers[reg as usize] += 1,
            Inst::Dec(Arg::Reg(reg)) => registers[reg as usize] -= 1,
            Inst::Jnz(val, offset) => if val.get(&registers) != 0 { ip_offset = offset.get(&registers) },
            Inst::Out(val) => {
                if val.get(&registers) != expected_out {
                    // Not a 0, 1, 0... clock signal
                    return false;
                }
                expected_out = (expected_out + 1) % 2;                
            }
            _ => println!("Skip: {:?}", insts[ip]), // Other combinations are no-ops
        }
        ip = ((ip as i64) + ip_offset) as usize;
    }

    // Went out of bounds instead of creating an infinite loop
    false
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day25.txt").unwrap();
    let insts = parse_instructions(&puzzle_input);

    for a in 0.. {
        let mut registers = [a, 0, 0, 0];
        if generates_clock(&insts, &mut registers) {
            println!("Part 1 answer: {}", a);
            break;
        }
    }
}