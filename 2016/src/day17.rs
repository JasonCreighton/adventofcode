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

fn shortest_path(passcode: &[u8]) -> Vec<u8> {
    let mut worklist: VecDeque<((i32, i32), Vec<u8>)> = VecDeque::new();
    worklist.push_back(((0, 0), Vec::new()));

    while let Some((position, path)) = worklist.pop_front() {
        // Did we find the goal?
        if position == (3, 3) {
            return path;
        }

        // Add any successor positions to the worklist
        for (dir, new_position) in legal_moves(position, passcode, path.as_slice()) {
            let mut new_path = path.clone();
            new_path.push(dir);
            worklist.push_back((new_position, new_path));
        }
    }

    panic!("Should have found goal in worklist loop");
}

#[test]
fn test_example() {
    assert_eq!(shortest_path(b"ihgpwlah").as_slice(), b"DDRRRD");
    assert_eq!(shortest_path(b"kglvqrro").as_slice(), b"DDUDRLRRUDRD");
    assert_eq!(shortest_path(b"ulqzkmiv").as_slice(), b"DRURDRUDDLLDLUURRDULRLDUUDDDRR");
}

pub fn run() {
    const PUZZLE_INPUT: &[u8] = b"pslxynzg";

    println!("Part 1 answer: {}", String::from_utf8(shortest_path(PUZZLE_INPUT)).unwrap());
}