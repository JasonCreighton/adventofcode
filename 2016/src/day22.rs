use regex::Regex;

fn parse_nodes(puzzle_input: &str) -> Vec<(i32, i32, i32, i32, i32)> {
    let re_node = Regex::new(r"^/dev/grid/node-x([0-9]+)-y([0-9]+) +([0-9]+)T +([0-9]+)T +([0-9]+)T +[0-9]+%$").unwrap();

    puzzle_input.lines().skip(2).map(|line|
        if let Some(captures) = re_node.captures(line) {
            (
                captures[1].parse().unwrap(),
                captures[2].parse().unwrap(),
                captures[3].parse().unwrap(),
                captures[4].parse().unwrap(),
                captures[5].parse().unwrap(),
            )
        } else {            
            panic!("Unrecognized line: '{}'", line);
        }        
    ).collect()
}

fn count_viable_pairs(nodes: &[(i32, i32, i32, i32, i32)]) -> i32 {
    let mut viable_pairs = 0;
    // Stupid O(n^2) for now because I assume part 2 will be a curveball
    for &(a_x, a_y, _, a_used, _) in nodes {
        for &(b_x, b_y, _, _, b_avail) in nodes {
            if !(a_x == b_x && a_y == b_y) && a_used > 0 && a_used <= b_avail {
                viable_pairs += 1;
            }
        }
    }

    viable_pairs
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day22.txt").unwrap();
    let nodes = parse_nodes(&puzzle_input);
    let viable_pairs = count_viable_pairs(&nodes);

    println!("Part 1 answer: {}", viable_pairs);
}