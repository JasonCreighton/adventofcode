fn expand_to(data: &mut Vec<u8>, length: usize) {
    while data.len() < length {
        data.push(0);
        for i in (0..(data.len()-1)).rev() {
            data.push(if data[i] == 0 { 1 } else { 0 });
        }
    }
    data.truncate(length);
}

fn find_checksum(data: Vec<u8>) -> Vec<u8> {    
    if (data.len() % 2) == 0 {
        let mut checksum: Vec<u8> = Vec::new();
        for i in (0..data.len()).step_by(2) {
            checksum.push(if data[i] == data[i+1] { 1 } else { 0 });
        }

        find_checksum(checksum)
    } else {
        data
    }
}

fn expand_and_checksum(mut data: Vec<u8>, length: usize) -> Vec<u8> {
    expand_to(&mut data, length);
    find_checksum(data)
}

fn binary_string_to_vec(input: &str) -> Vec<u8> {
    input.chars().map(|ch| (ch as u8) - b'0').collect()
}

fn vec_to_binary_string(input: &Vec<u8>) -> String {
    input.iter().map(|d| d.to_string()).collect::<Vec<_>>().join("")
}

#[test]
fn test_example() {
    assert_eq!(expand_and_checksum(binary_string_to_vec("110010110100"), 12), binary_string_to_vec("100"));
    assert_eq!(expand_and_checksum(binary_string_to_vec("10000"), 20), binary_string_to_vec("01100"));
}

pub fn run() {
    let puzzle_input = binary_string_to_vec("10001001100000001");
    println!("Part 1 answer: {}", vec_to_binary_string(&expand_and_checksum(puzzle_input.clone(), 272)));
    println!("Part 2 answer: {}", vec_to_binary_string(&expand_and_checksum(puzzle_input.clone(), 35651584)));
}