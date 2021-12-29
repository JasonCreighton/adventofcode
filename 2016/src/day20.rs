fn lowest_allowed(blocklist: &[(u32, u32)]) -> u32 {
    let mut addresses_to_try: Vec<u32> = blocklist.iter().map(|&(_low, high)| if high != u32::MAX { high + 1 } else { high }).collect();
    addresses_to_try.sort();

    for address in addresses_to_try {
        if blocklist.iter().all(|&(low, high)| address < low || address > high) {
            return address;
        }
    }

    panic!("Allowed address not found!");
}

fn total_blocked(blocklist: &[(u32, u32)]) -> i64 {
    // assumes blocklist is already sorted
    let mut blocked: i64 = 0;

    let mut blocked_up_to: i64 = -1;
    for i in 0..blocklist.len() {
        let (begin, end) = blocklist[i];        
        let effective_begin = (begin as i64).max(blocked_up_to + 1);

        blocked += ((end as i64) - effective_begin + 1).max(0);

        blocked_up_to = blocked_up_to.max(end as i64);
    }

    blocked
}

#[allow(dead_code)]
fn total_allowed_brute_force(blocklist: &[(u32, u32)]) -> u32 {
    let mut allowed = vec![true; 1 << 32];
    for &(begin, end) in blocklist {
        for i in begin..=end {
            allowed[i as usize] = false;
        }
    }

    allowed.iter().filter(|&&b| b).count() as u32
}

fn parse_input(puzzle_input: &str) -> Vec<(u32, u32)> {
    let mut pairs = Vec::new();
    for line in puzzle_input.lines() {
        let split_line: Vec<&str> = line.split('-').collect();
        pairs.push((split_line[0].parse().unwrap(), split_line[1].parse().unwrap()));
    }
    pairs.sort();

    pairs
}

#[test]
fn test_example() {
    let blocklist = parse_input("\
5-8
0-2
4-7
");
    assert_eq!(lowest_allowed(&blocklist), 3);
    assert_eq!(10 - total_blocked(&blocklist), 2);
}

pub fn run() {
    let blocklist = parse_input(&std::fs::read_to_string("inputs/day20.txt").unwrap());
    println!("Part 1 answer: {}", lowest_allowed(&blocklist));
    println!("Part 2 answer: {}", (1 << 32) - total_blocked(&blocklist));
    // println!("Part 2 answer: {} (brute force)", total_allowed_brute_force(&blocklist));
}