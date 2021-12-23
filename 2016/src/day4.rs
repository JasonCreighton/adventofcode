use std::collections::HashMap;

fn checksum(freqs: &HashMap<char, i32>) -> String {
    let mut freq_vec: Vec<(char, i32)> = freqs.iter().map(|(ch, freq)| (*ch, *freq)).collect();
    freq_vec.sort_by_key(|(ch, freq)| (-freq, *ch));
    freq_vec[0..5].iter().map(|(ch, _)| ch).collect()
}

fn real_sector_id(room: &str) -> Option<i32> {
    let room_parts: Vec<&str> = room.split(&['-', '[', ']'][..]).collect();
    let mut freqs: HashMap<char, i32> = HashMap::new();
    for i in 0..(room_parts.len()-3) {
        for ch in room_parts[i].chars() {
            *freqs.entry(ch).or_default() += 1;
        }
    }

    let provided_checksum = room_parts[room_parts.len()-2];
    let sector_id = room_parts[room_parts.len()-3].parse().unwrap();

    if provided_checksum == checksum(&freqs) { Some(sector_id) } else { None }
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day4.txt").unwrap();
    let mut num_real = 0;

    for room in puzzle_input.lines() {
        num_real += real_sector_id(room).unwrap_or(0);
    }

    println!("Part 1 answer: {}", num_real);
}