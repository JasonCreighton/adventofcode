use std::collections::HashMap;

fn decrypt(input: &str, shift_amount: u32) -> String {
    input.chars().map(|ch| char::from_u32((((ch as u32) - ('a' as u32) + shift_amount) % 26) + ('a' as u32)).unwrap()).collect()
}

fn checksum(freqs: &HashMap<char, u32>) -> String {
    let mut freq_vec: Vec<(char, u32)> = freqs.iter().map(|(ch, freq)| (*ch, *freq)).collect();
    freq_vec.sort_by_key(|(ch, freq)| (-(*freq as i32), *ch));
    freq_vec[0..5].iter().map(|(ch, _)| ch).collect()
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day4.txt").unwrap();
    let mut sum_of_real_sector_ids = 0;

    println!("Decrypted rooms matching northpole:");

    for room in puzzle_input.lines() {
        let room_parts: Vec<&str> = room.split(&['-', '[', ']'][..]).collect();
        let mut freqs: HashMap<char, u32> = HashMap::new();
        for i in 0..(room_parts.len()-3) {
            for ch in room_parts[i].chars() {
                *freqs.entry(ch).or_default() += 1;
            }
        }

        let provided_checksum = room_parts[room_parts.len()-2];
        let sector_id = room_parts[room_parts.len()-3].parse().unwrap();

        if provided_checksum == checksum(&freqs) {            
            sum_of_real_sector_ids += sector_id;
            let decrypted_words = room_parts[0..(room_parts.len()-3)].iter().map(|w| decrypt(w, sector_id)).collect::<Vec<_>>();
            if decrypted_words[0] == "northpole" {
                for word in decrypted_words {
                    print!("{} ", word );
                }
                println!("{}", sector_id);
            }
        }
    }

    println!("Part 1 answer: {}", sum_of_real_sector_ids);
}