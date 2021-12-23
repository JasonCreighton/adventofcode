fn part1(puzzle_input: &str) -> i32 {
    let mut x = 1;
    let mut y = 1;
    let mut code = 0;
    for line in puzzle_input.lines() {
        for cmd in line.chars() {
            match cmd {
                'U' => y = (y - 1).max(0),
                'D' => y = (y + 1).min(2),
                'L' => x = (x - 1).max(0),
                'R' => x = (x + 1).min(2),
                _ => panic!("Unknown command"),
            }
        }
        let digit = (y * 3) + x + 1;
        code = (code * 10) + digit;
    }

    code
}

fn part2_update_position(x: &mut i32, y: &mut i32, dx: i32, dy: i32) {
    let (new_x, new_y) = (*x + dx, *y + dy);
    if new_x < 0 || new_x > 4 { return; }
    if new_y < 0 || new_y > 4 { return; }
    let x_allowed_distance_from_center = 2 - (new_y - 2).abs();
    if (new_x - 2).abs() > x_allowed_distance_from_center { return; }

    *x = new_x;
    *y = new_y;
}

fn part2(puzzle_input: &str) -> String {
    let mut x = 0;
    let mut y = 2;
    let code_table = [
        [' ', ' ', '1', ' ', ' '],
        [' ', '2', '3', '4', ' '],
        ['5', '6', '7', '8', '9'],
        [' ', 'A', 'B', 'C', ' '],
        [' ', ' ', 'D', ' ', ' '],
    ];
    let mut code = String::new();
    for line in puzzle_input.lines() {
        for cmd in line.chars() {
            match cmd {
                'U' => part2_update_position(&mut x, &mut y,  0, -1),
                'D' => part2_update_position(&mut x, &mut y,  0,  1),
                'L' => part2_update_position(&mut x, &mut y, -1,  0),
                'R' => part2_update_position(&mut x, &mut y,  1,  0),
                _ => panic!("Unknown command"),
            }
        }
        code.push(code_table[y as usize][x as usize]);
    }

    code
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day2.txt").unwrap();
    println!("Part 1 answer: {}", part1(&puzzle_input));
    println!("Part 2 answer: {}", part2(&puzzle_input));
}