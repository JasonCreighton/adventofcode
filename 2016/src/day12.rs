use regex::Regex;

const NUM_REGISTERS: usize = 4;

#[derive(Debug, Copy, Clone)]
enum Value {
    Const(i64),
    Reg(u8),
}

impl Value {
    fn get(&self, registers: &[i64; NUM_REGISTERS]) -> i64 {
        match self {
            Self::Const(n) => *n,
            Self::Reg(r) => registers[*r as usize],
        }
    }
}

#[derive(Debug, Copy, Clone)]
enum Inst {
    Cpy(Value, u8),
    Inc(u8),
    Dec(u8),
    Jnz(Value, isize),
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

fn parse_value(op: &str) -> Value {
    match register_index(op) {
        Some(r) => Value::Reg(r),
        None => Value::Const(op.parse().unwrap()),
    }
}

fn parse_instructions(puzzle_input: &str) -> Vec<Inst> {
    let re_cpy = Regex::new(r"^cpy ([abcd]|-?[0-9]+) ([abcd])$").unwrap();
    let re_inc = Regex::new(r"^inc ([abcd])$").unwrap();
    let re_dec = Regex::new(r"^dec ([abcd])$").unwrap();
    let re_jnz = Regex::new(r"^jnz ([abcd]|-?[0-9]+) (-?[0-9]+)$").unwrap();

    let mut insts = Vec::new();
    for line in puzzle_input.lines() {
        if let Some(captures) = re_cpy.captures(line) {
            insts.push(Inst::Cpy(parse_value(&captures[1]), register_index(&captures[2]).unwrap()));
        } else if let Some(captures) = re_inc.captures(line) {
            insts.push(Inst::Inc(register_index(&captures[1]).unwrap()));
        } else if let Some(captures) = re_dec.captures(line) {
            insts.push(Inst::Dec(register_index(&captures[1]).unwrap()));
        } else if let Some(captures) = re_jnz.captures(line) {
            insts.push(Inst::Jnz(parse_value(&captures[1]), captures[2].parse().unwrap()));
        } else {
            panic!("Unmatched instruction: '{}'", line);
        }
    }

    insts
}

fn run_instructions(insts: &[Inst], registers: &mut [i64; NUM_REGISTERS]) {
    let mut ip: usize = 0;

    while ip < insts.len() {
        let mut ip_offset: isize = 1;
        match insts[ip] {
            Inst::Cpy(src, dest) => registers[dest as usize] = src.get(&registers),
            Inst::Inc(reg) => registers[reg as usize] += 1,
            Inst::Dec(reg) => registers[reg as usize] -= 1,
            Inst::Jnz(val, offset) => if val.get(&registers) != 0 { ip_offset = offset },
        }
        ip = ((ip as isize) + ip_offset) as usize;
    }
}

#[test]
fn test_example() {
    const EXAMPLE_INPUT: &str = "\
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
";
    let insts = parse_instructions(EXAMPLE_INPUT);
    let mut registers = [0i64; NUM_REGISTERS];
    run_instructions(&insts, &mut registers);
    assert_eq!(registers[0], 42);
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day12.txt").unwrap();
    let insts = parse_instructions(&puzzle_input);

    let mut part1_registers = [0i64; NUM_REGISTERS];
    run_instructions(&insts, &mut part1_registers);
    println!("Part 1 answer: {}", part1_registers[0]);

    let mut part2_registers = [0, 0, 1, 0];
    run_instructions(&insts, &mut part2_registers);
    println!("Part 2 answer: {}", part2_registers[0]);
}