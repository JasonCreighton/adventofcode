fn lowest_allowed(blocklist: &[(u32, u32)]) -> u32 {
    let mut addresses_to_try: Vec<u32> = blocklist.iter().map(|&(_low, high)| high + 1).collect();
    addresses_to_try.sort();

    for address in addresses_to_try {
        if blocklist.iter().all(|&(low, high)| address < low || address > high) {
            return address;
        }
    }

    panic!("Allowed address not found!");
}

fn parse_input(puzzle_input: &str) -> Vec<(u32, u32)> {
    let mut pairs = Vec::new();
    for line in puzzle_input.lines() {
        let split_line: Vec<&str> = line.split('-').collect();
        pairs.push((split_line[0].parse().unwrap(), split_line[1].parse().unwrap()));
    }

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
}

pub fn run() {
    let blocklist = parse_input(&std::fs::read_to_string("inputs/day20.txt").unwrap());
    println!("Part 1 answer: {}", lowest_allowed(&blocklist))
}