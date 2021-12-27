use std::collections::HashMap;

const PUZZLE_INPUT: &str = "zpqevtbw";

fn first_triplet(bytes: &[u8]) -> Option<u8> {
    for i in 0..bytes.len()-2 {
        if bytes[i] == bytes[i+1] && bytes[i+1] == bytes[i+2] {
            return Some(bytes[i]);
        }
    }

    return None;
}

fn index_of_nth_key(key_number: usize, salt: &str, num_hashes: i32) -> u64 {
    let mut keys: Vec<u64> = Vec::new();
    let mut potential_keys: HashMap<u8, Vec<u64>> = HashMap::new();
    for b in b'0'..=b'9' { potential_keys.insert(b, Vec::new()); }
    for b in b'a'..=b'f' { potential_keys.insert(b, Vec::new()); }
    let mut index: u64 = 0;

    while keys.len() < key_number || index <= (keys[key_number - 1] + 1000) {
        let mut bytes: Vec<u8> = Vec::new();
        bytes.extend_from_slice(format!("{}{}", salt, index).as_bytes());
        for _ in 0..num_hashes {
            let new_hash = format!("{:x}", md5::compute(bytes.as_slice()));
            bytes.clear();
            bytes.extend_from_slice(new_hash.as_bytes());
        }

        // Check for groups of 5 to validate previous potential keys
        for i in 0..bytes.len()-4 {
            let b = bytes[i];
            if bytes[i+1] == b && bytes[i+2] == b && bytes[i+3] == b && bytes[i+4] == b {
                // Found a group of 5, so iterate and clear the vector for this particular character
                for potential_index in potential_keys.get_mut(&b).unwrap().drain(..) {
                    if index - potential_index <= 1000 {
                        keys.push(potential_index);
                    } 
                }
            }
        }

        // Check for groups of 3 as potential future keys
        if let Some(byte) = first_triplet(bytes.as_slice()) {
            potential_keys.get_mut(&byte).unwrap().push(index);
        }

        index += 1;
    }

    // Need to sort, because we can find them out-of-order
    keys.sort();

    keys[key_number - 1]
}

#[test]
fn test_example() {
    assert_eq!(index_of_nth_key(1, "abc", 1), 39);
    assert_eq!(index_of_nth_key(2, "abc", 1), 92);
    assert_eq!(index_of_nth_key(64, "abc", 1), 22728);
}

pub fn run() {
    println!("Part 1 answer: {}", index_of_nth_key(64, PUZZLE_INPUT, 1));
    println!("Part 2 answer: {}", index_of_nth_key(64, PUZZLE_INPUT, 2017));
}