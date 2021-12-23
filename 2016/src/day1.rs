use std::collections::HashSet;

fn commands_to_positions(commands: &[&str]) -> Vec<(i32, i32)> {
    let mut x = 0;
    let mut y = 0;
    let mut dx = 0;
    let mut dy = 1;
    let mut positions = Vec::new();
    positions.push((x, y));

    for cmd in commands {
        let (turn, dist_str) = cmd.split_at(1);
        let dist : i32 = dist_str.parse().unwrap();
        let old_dx = dx;
        let old_dy = dy;
        match turn {
            "R" => { dx =  old_dy; dy = -old_dx; }
            "L" => { dx = -old_dy; dy =  old_dx; }
            _ => panic!("unknown command")
        }
        for _ in 0..dist {
            x += dx;
            y += dy;
            positions.push((x, y));
        }
    }

    return positions;
}

fn first_position_visited_twice(positions: &[(i32, i32)]) -> (i32, i32) {
    let mut visited = HashSet::new();

    for pos in positions {
        if visited.contains(pos) {
            return *pos;
        }

        visited.insert(pos);
    }

    panic!("No position visited twice!");
}

fn manhattan_distance(pos: (i32, i32)) -> i32 {
    let (x, y) = pos;
    x.abs() + y.abs()
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day1.txt").unwrap();
    let commands = puzzle_input.split(',').map(|s| s.trim()).collect::<Vec<_>>();
    let positions = commands_to_positions(commands.as_slice());

    println!("Part 1 answer: {}", manhattan_distance(*positions.last().unwrap()));
    println!("Part 2 answer: {}", manhattan_distance(first_position_visited_twice(&positions)));
}