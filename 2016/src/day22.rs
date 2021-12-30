use std::collections::{HashSet, VecDeque};

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

struct Map {
    width: i8,
    height: i8,
    walls: HashSet<(i8, i8)>,
    starting_empty: (i8, i8),
}

fn extract_map(nodes: &[(i32, i32, i32, i32, i32)]) -> Map {
    let mut walls: HashSet<(i8, i8)> = HashSet::new();
    let mut empty: Option<(i8, i8)> = None;
    let mut width: i8 = 0;
    let mut height: i8 = 0;

    for &(x, y, _, used, _) in nodes {
        width = width.max((x + 1) as i8);
        height = height.max((y + 1) as i8);
        if used == 0 {
            empty = Some((x as i8, y as i8));
        }
        if used > 250 {
            walls.insert((x as i8, y as i8));
        }
    }

    Map { width, height, walls, starting_empty: empty.unwrap(), }
}

fn fewest_steps(map: &Map) -> u32 {
    let starting_data = (map.width - 1, 0);
    let mut worklist: VecDeque<(((i8, i8), (i8, i8)), u32)> = VecDeque::new();
    let mut visited: HashSet<((i8, i8), (i8, i8))> = HashSet::new();
    worklist.push_back(((map.starting_empty, starting_data), 0));

    while let Some(((empty, data), depth)) = worklist.pop_front() {
        // Have we been here before?
        if visited.contains(&(empty, data)) { continue; }
        visited.insert((empty, data));

        // Did we find the goal?
        if data == (0, 0) {
            return depth;
        }

        // Add possible "moves" of empty square to worklist
        for (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
            let new_empty = (empty.0 + dx, empty.1 + dy);
            if new_empty.0 < 0 || new_empty.0 >= map.width || new_empty.1 < 0 || new_empty.1 >= map.height { continue; }
            if map.walls.contains(&new_empty) { continue; }

            let new_data = if new_empty == data { empty } else { data };
            worklist.push_back(((new_empty, new_data), depth + 1));
        }
    }

    panic!("Did not find path to goal!");
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day22.txt").unwrap();
    let nodes = parse_nodes(&puzzle_input);
    let viable_pairs = count_viable_pairs(&nodes);
    let map = extract_map(&nodes);

    println!("Part 1 answer: {}", viable_pairs);
    println!("Part 2 answer: {}", fewest_steps(&map));
}