use std::collections::{HashSet, VecDeque};

fn is_wall(seed: i32, x: i32, y: i32) -> bool {
    if x < 0 || y < 0 {
        true
    } else {
        let n = x*x + 3*x + 2*x*y + y + y*y + seed;
        (n.count_ones() & 1) == 1
    }
}

// Dumb breadth-first search. I think A* or something would be better, but it
// seems to me only by a constant factor?
fn fewest_steps(seed: i32, from: (i32, i32), to: (i32, i32), part2: bool) -> i32 {
    let mut worklist: VecDeque<((i32, i32), i32)> = VecDeque::new();
    let mut visited: HashSet<(i32, i32)> = HashSet::new();
    worklist.push_back((from, 0));

    while let Some((position, depth)) = worklist.pop_front() {
        // Did we find the goal?
        if part2 {
            if depth > 50 {
                return visited.len() as i32;
            }
        } else {
            if position == to {
                return depth;
            }            
        }

        // Have we been here before?
        if visited.contains(&position) { continue; }

        visited.insert(position);

        // Add any successor positions to the worklist
        for (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
            let new_position = (position.0 + dx, position.1 + dy);
            if !is_wall(seed, new_position.0, new_position.1) {
                worklist.push_back((new_position, depth + 1));
            }
        }
    }

    panic!("Should have found goal in worklist loop");
}

#[test]
fn test_example() {
    assert_eq!(fewest_steps(10, (1, 1), (7, 4), false), 11);
}

pub fn run() {
    println!("Part 1 answer: {}", fewest_steps(1364, (1, 1), (31, 39), false));
    println!("Part 2 answer: {}", fewest_steps(1364, (1, 1), (1, 1), true));
}