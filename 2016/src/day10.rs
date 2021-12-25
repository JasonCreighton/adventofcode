use std::collections::VecDeque;
use regex::Regex;

#[derive(Debug, Copy, Clone)]
enum Dest {
    Bot(usize),
    Output(usize),
}

#[derive(Debug)]
struct Bot {
    chips: Vec<i32>,
    low_dest: Dest,
    high_dest: Dest,
}

fn parse_instructions(insts: &str) -> Vec<Bot> {
    let mut bots: Vec<Bot> = Vec::new();
    let re_value = Regex::new(r"^value ([0-9]+) goes to bot ([0-9]+)$").unwrap();
    let re_bot = Regex::new(r"^bot ([0-9]+) gives low to (bot|output) ([0-9]+) and high to (bot|output) ([0-9]+)$").unwrap();

    // Parse all "bot" lines first
    for line in insts.lines() {
        if let Some(captures) = re_bot.captures(line) {            
            let bot_index: usize = captures[1].parse().unwrap();
            let low_dest_what = &captures[2];
            let low_dest_index: usize = captures[3].parse().unwrap();
            let high_dest_what = &captures[4];
            let high_dest_index: usize = captures[5].parse().unwrap();

            while !(bot_index < bots.len()) {
                bots.push(Bot { chips: Vec::new(), low_dest: Dest::Output(0), high_dest: Dest::Output(0) });
            }

            bots[bot_index].low_dest = if low_dest_what == "bot" { Dest::Bot(low_dest_index) } else { Dest::Output(low_dest_index) };
            bots[bot_index].high_dest = if high_dest_what == "bot" { Dest::Bot(high_dest_index) } else { Dest::Output(high_dest_index) };
        } else if let Some(captures) = re_value.captures(line) {
            let value: i32 = captures[1].parse().unwrap();
            let bot_index: usize = captures[2].parse().unwrap();

            while !(bot_index < bots.len()) {
                bots.push(Bot { chips: Vec::new(), low_dest: Dest::Output(0), high_dest: Dest::Output(0) });
            }

            bots[bot_index].chips.push(value);
        } else {
            panic!("Don't know what to do with '{}'", line);
        }
    }

    bots
}

fn run_bots(bots: &mut Vec<Bot>, outputs: &mut Vec<i32>) {
    let mut bot_worklist: VecDeque<usize> = VecDeque::new();
    for i in 0..bots.len() {
        bot_worklist.push_back(i);    
    }

    while let Some(bot_index) = bot_worklist.pop_front() {
        let bot = &mut bots[bot_index];
        if bot.chips.len() == 2 {
            let low = bot.chips[0].min(bot.chips[1]);
            let high = bot.chips[0].max(bot.chips[1]);
            bot.chips.clear();
            if low == 17 && high == 61 {
                println!("Part 1 answer: {}", bot_index);
            }
            for (dest, val) in [(bot.low_dest, low), (bot.high_dest, high)] {
                match dest {
                    Dest::Bot(dest_bot_index) => {
                        bots[dest_bot_index].chips.push(val);
                        bot_worklist.push_back(dest_bot_index);
                    },
                    Dest::Output(output_index) => {
                        while !(output_index < outputs.len()) { outputs.push(0) }
                        outputs[output_index] = val;
                    },
                }
            }
        }
    }
}

#[test]
fn test_example() {
    const EXAMPLE_PUZZLE_INPUT: &str = "\
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
";
    let mut bots = parse_instructions(EXAMPLE_PUZZLE_INPUT);
    let mut outputs = Vec::new();

    run_bots(&mut bots, &mut outputs);
    assert_eq!(outputs[0], 5);
    assert_eq!(outputs[1], 2);
    assert_eq!(outputs[2], 3);
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day10.txt").unwrap();
    let mut bots = parse_instructions(&puzzle_input);
    let mut outputs = Vec::new();

    run_bots(&mut bots, &mut outputs);

    println!("Part 2 answer: {}", outputs[0] * outputs[1] * outputs[2]);
}