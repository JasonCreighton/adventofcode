const PUZZLE_INPUT: &str = ".^^^^^.^^.^^^.^...^..^^.^.^..^^^^^^^^^^..^...^^.^..^^^^..^^^^...^.^.^^^^^^^^....^..^^^^^^.^^^.^^^.^^";

const NEW_TILE_IS_TRAP: [bool; 8] = [
           // LCR (left/center/right)
    false, // 000
    true,  // 001
    false, // 010
    true,  // 011
    true,  // 100
    false, // 101
    true,  // 110
    false, // 111
];

fn parse_input(input: &str) -> Vec<bool> {
    input.chars().map(|ch| ch == '^').collect()
}

fn make_next_row(prev_row: &[bool]) -> Vec<bool> {
    let mut row = vec![false; prev_row.len()];
    for i in 0..row.len() {
        let trap_left   = if i > 0 { prev_row[i-1] } else { false };
        let trap_center = prev_row[i];
        let trap_right  = if i < (prev_row.len() - 1) { prev_row[i+1] } else { false };
        let lookup = ((trap_left as usize) << 2) | ((trap_center as usize) << 1) | ((trap_right as usize) << 0);
        row[i] = NEW_TILE_IS_TRAP[lookup];
    }

    row
}

fn make_room(initial_row: Vec<bool>, num_rows: usize) -> Vec<Vec<bool>> {
    let mut rows = Vec::new();
    let mut row = initial_row;
    for _ in 0..(num_rows-1) {
        let next_row = make_next_row(row.as_slice());
        rows.push(row);
        row = next_row;
    }
    rows.push(row);

    rows
}

fn count_safe(room: &Vec<Vec<bool>>) -> usize {
    room.iter().map(|row| row.iter().filter(|&&tile| !tile).count()).sum()
}

#[test]
fn test_example() {
    assert_eq!(count_safe(&make_room(parse_input(".^^.^.^^^^"), 10)), 38);
}

pub fn run() {
    println!("Part 1 answer: {}", count_safe(&make_room(parse_input(PUZZLE_INPUT), 40)));
    println!("Part 2 answer: {}", count_safe(&make_room(parse_input(PUZZLE_INPUT), 400000)));
}