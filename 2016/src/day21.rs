fn run_instructions(puzzle_input: &str, password: &mut Vec<u8>) {
    for line in puzzle_input.lines() {
        let line_parts: Vec<&str> = line.split_whitespace().collect();
        match (line_parts[0], line_parts[1]) {
            ("swap", "position") => {
                let x = line_parts[2].parse().unwrap();
                let y = line_parts[5].parse().unwrap();
                password.swap(x, y);
            },
            ("swap", "letter") => {
                let letter_x = line_parts[2].chars().nth(0).unwrap() as u8;
                let letter_y = line_parts[5].chars().nth(0).unwrap() as u8;
                let x = password.iter().position(|&ch| ch == letter_x).unwrap();
                let y = password.iter().position(|&ch| ch == letter_y).unwrap();
                password.swap(x, y);
            },
            ("rotate", "left") => password.rotate_left(line_parts[2].parse().unwrap()),
            ("rotate", "right") => password.rotate_right(line_parts[2].parse().unwrap()),
            ("rotate", "based") => {
                let letter_x = line_parts[6].chars().nth(0).unwrap() as u8;
                let x = password.iter().position(|&ch| ch == letter_x).unwrap();
                let rotate_right_amount = (1 + x + (if x >= 4 { 1 } else { 0 })) % password.len();
                password.rotate_right(rotate_right_amount);
            },
            ("reverse", "positions") => {
                let x = line_parts[2].parse().unwrap();
                let y = line_parts[4].parse().unwrap();
                password[x..=y].reverse();
            },
            ("move", "position") => {
                let x = line_parts[2].parse().unwrap();
                let y = line_parts[5].parse().unwrap();
                let letter_x = password.remove(x);
                password.insert(y, letter_x);
            },
            _ => panic!("Unexpected input"),
        }
    }
}

#[test]
fn test_example() {
    const EXAMPLE_INPUT: &str = "\
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
";
    let mut password = b"abcde".to_vec();
    run_instructions(EXAMPLE_INPUT, &mut password);
    assert_eq!(password, b"decab".to_vec());
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day21.txt").unwrap();
    let mut password = b"abcdefgh".to_vec();
    run_instructions(&puzzle_input, &mut password);
    println!("Part 1 answer: {}", String::from_utf8(password).unwrap());
}