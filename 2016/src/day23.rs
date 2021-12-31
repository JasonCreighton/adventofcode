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
    Tgl(Arg),
}

impl Inst {
    fn toggle(self) -> Self {
        match self {
            Self::Cpy(val, reg) => Self::Jnz(val, reg),
            Self::Inc(reg) => Self::Dec(reg),
            Self::Dec(reg) => Self::Inc(reg),
            Self::Jnz(val, offset) => Self::Cpy(val, offset),
            Self::Tgl(offset) => Self::Inc(offset),
        }
    }
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
    let re_tgl = Regex::new(r"^tgl ([abcd]|-?[0-9]+)$").unwrap();

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
        } else if let Some(captures) = re_tgl.captures(line) {
            insts.push(Inst::Tgl(parse_arg(&captures[1])));            
        } else {
            panic!("Unmatched instruction: '{}'", line);
        }
    }

    insts
}

fn run_instructions(insts: &mut [Inst], registers: &mut [i64; NUM_REGISTERS]) {
    let mut ip: usize = 0;

    while ip < insts.len() {
        let mut ip_offset: i64 = 1;
        match insts[ip] {
            Inst::Cpy(src, Arg::Reg(dest)) => registers[dest as usize] = src.get(&registers),
            Inst::Inc(Arg::Reg(reg)) => registers[reg as usize] += 1,
            Inst::Dec(Arg::Reg(reg)) => registers[reg as usize] -= 1,
            Inst::Jnz(val, offset) => if val.get(&registers) != 0 { ip_offset = offset.get(&registers) },
            Inst::Tgl(val) => {
                let inst_idx = (ip as i64) + val.get(&registers);
                if inst_idx >= 0 && inst_idx < (insts.len() as i64) {
                    let inst = &mut insts[inst_idx as usize];
                    *inst = inst.toggle();                    
                }
            },
            _ => println!("Skip: {:?}", insts[ip]), // Other combinations are no-ops
        }
        ip = ((ip as i64) + ip_offset) as usize;
    }
}

#[test]
fn test_example() {
    const EXAMPLE_INPUT: &str = "\
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
";
    let mut insts = parse_instructions(EXAMPLE_INPUT);
    let mut registers = [0i64; NUM_REGISTERS];
    run_instructions(&mut insts, &mut registers);
    assert_eq!(registers[0], 3);
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day23.txt").unwrap();
    let orig_insts = parse_instructions(&puzzle_input);

    let mut part1_registers = [7, 0, 0, 0];
    run_instructions(&mut orig_insts.clone(), &mut part1_registers);
    println!("Part 1 answer: {}", part1_registers[0]);

    let mut part2_registers = [12, 0, 0, 0];
    run_instructions(&mut orig_insts.clone(), &mut part2_registers);
    println!("Part 2 answer: {}", part2_registers[0]);
}