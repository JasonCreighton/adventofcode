fn run_instructions(puzzle_input: &str, password: &mut Vec<u8>, backwards: bool) {
    let mut lines: Vec<&str> = puzzle_input.lines().collect();
    let mut rotate_based_forwards = vec![0; password.len()];
    let mut rotate_based_backwards = vec![0; password.len()];

    for starting_index in 0..password.len() {
        let ending_index = (starting_index + (1 + starting_index + (if starting_index >= 4 { 1 } else { 0 }))) % password.len();
        rotate_based_forwards[starting_index] = ending_index;
    }
    for starting_index in 0..password.len() {
        let ending_index = rotate_based_forwards[starting_index];
        rotate_based_backwards[ending_index] = starting_index;
    }

    if backwards { lines.reverse(); }

    for line in lines {
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
            ("rotate", "based") => {
                let letter_x = line_parts[6].chars().nth(0).unwrap() as u8;
                let x = password.iter().position(|&ch| ch == letter_x).unwrap();
                let ending_index = if backwards { rotate_based_backwards[x] } else { rotate_based_forwards[x] };
                let rotate_right_amount = (ending_index + password.len() - x) % password.len();
                password.rotate_right(rotate_right_amount);
            },
            ("rotate", direction) => {
                let arg: i32 = line_parts[2].parse().unwrap();
                let len = password.len() as i32;
                let mut rotate_right_amount = if direction == "right" { arg } else { -arg };
                if backwards { rotate_right_amount = -rotate_right_amount }

                password.rotate_right(((rotate_right_amount + len) % len) as usize);
            }
            ("reverse", "positions") => {
                let x = line_parts[2].parse().unwrap();
                let y = line_parts[4].parse().unwrap();
                password[x..=y].reverse();
            },
            ("move", "position") => { 
                let arg_x = line_parts[2].parse().unwrap();
                let arg_y = line_parts[5].parse().unwrap();
                let (x, y) = if backwards { (arg_y, arg_x) } else { (arg_x, arg_y) };
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
    let starting_password = b"abcde".to_vec();
    let scrambled_password = b"decab".to_vec();
    let mut password = starting_password.clone();

    run_instructions(EXAMPLE_INPUT, &mut password, false);
    assert_eq!(password, scrambled_password);

    // I think this part of the test is only passing by coincidence...with a
    // length of 5, I don't think "rotate based on..." is always perfectly
    // reversible.
    run_instructions(EXAMPLE_INPUT, &mut password, true);
    assert_eq!(password, starting_password);
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day21.txt").unwrap();
    let mut password = b"abcdefgh".to_vec();

    run_instructions(&puzzle_input, &mut password, false);
    println!("Part 1 answer: {}", String::from_utf8(password).unwrap());

    let mut scrambled_password = b"fbgdceah".to_vec();
    run_instructions(&puzzle_input, &mut scrambled_password, true);
    println!("Part 2 answer: {}", String::from_utf8(scrambled_password).unwrap());
}