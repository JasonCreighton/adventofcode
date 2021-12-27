use std::collections::VecDeque;

fn legal_moves(position: (i32, i32), passcode: &[u8], path: &[u8]) -> Vec<(u8, (i32, i32))> {
    let (x, y) = position;
    let mut moves = Vec::new();

    let mut md5_input = Vec::with_capacity(passcode.len() + path.len());
    md5_input.extend_from_slice(passcode);
    md5_input.extend_from_slice(path);
    let digest = md5::compute(md5_input);

    // Coordinate system has (0, 0) at upper-left
    let can_move_up    = ((digest[0] >> 4) & 0xf) > 0xa && y > 0;
    let can_move_down  = ((digest[0] >> 0) & 0xf) > 0xa && y < 3;
    let can_move_left  = ((digest[1] >> 4) & 0xf) > 0xa && x > 0;
    let can_move_right = ((digest[1] >> 0) & 0xf) > 0xa && x < 3;

    if can_move_up    { moves.push((b'U', (x, y - 1))); }
    if can_move_down  { moves.push((b'D', (x, y + 1))); }
    if can_move_left  { moves.push((b'L', (x - 1, y))); }
    if can_move_right { moves.push((b'R', (x + 1, y))); }

    moves
}

fn explore_paths(passcode: &[u8]) -> (Vec<u8>, usize) {
    let mut worklist: VecDeque<((i32, i32), Vec<u8>)> = VecDeque::new();
    let mut longest_path_length = 0;
    let mut shortest_path: Option<Vec<u8>> = None;
    worklist.push_back(((0, 0), Vec::new()));

    while let Some((position, path)) = worklist.pop_front() {
        // Did we find the goal?
        if position == (3, 3) {
            longest_path_length = longest_path_length.max(path.len());

            if shortest_path == None {
                shortest_path = Some(path);
            }
        } else {
            // Add any successor positions to the worklist
            for (dir, new_position) in legal_moves(position, passcode, path.as_slice()) {
                let mut new_path = path.clone();
                new_path.push(dir);
                worklist.push_back((new_position, new_path));
            }
        }
    }

    match shortest_path {
        Some(path) => (path, longest_path_length),
        _ => panic!("Should have found goal in worklist loop"),
    }
}

#[test]
fn test_example() {
    assert_eq!(explore_paths(b"ihgpwlah"), (b"DDRRRD".to_vec(), 370));
    assert_eq!(explore_paths(b"kglvqrro"), (b"DDUDRLRRUDRD".to_vec(), 492));
    assert_eq!(explore_paths(b"ulqzkmiv"), (b"DRURDRUDDLLDLUURRDULRLDUUDDDRR".to_vec(), 830));
}

pub fn run() {
    const PUZZLE_INPUT: &[u8] = b"pslxynzg";
    let (shortest_path, longest_path_length) = explore_paths(PUZZLE_INPUT);

    println!("Part 1 answer: {}", String::from_utf8(shortest_path).unwrap());
    println!("Part 2 answer: {}", longest_path_length);
}