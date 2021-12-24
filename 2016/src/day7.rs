use std::collections::HashSet;

fn supports_tls(ipv7_address: &str) -> bool {
    const ST_OUTSIDE_BRACKETS: usize = 0;
    const ST_INSIDE_BRACKETS: usize = 1;
    let mut found_abba = [false, false];

    let bytes = ipv7_address.as_bytes();
    let mut state = ST_OUTSIDE_BRACKETS;
    for i in 3..bytes.len() {
        if bytes[i] == b'[' {
            state = ST_INSIDE_BRACKETS;
        } else if bytes[i] == b']' {
            state = ST_OUTSIDE_BRACKETS;
        } else if bytes[i-3] == bytes[i] && bytes[i-2] == bytes[i-1] && bytes[i] != bytes[i-1] {
            found_abba[state] = true;
        }
    }

    found_abba[ST_OUTSIDE_BRACKETS] && !found_abba[ST_INSIDE_BRACKETS]
}

#[test]
fn test_supports_tls() {
    assert!(supports_tls("abba[mnop]qrst"));
    assert!(!supports_tls("abcd[bddb]xyyx"));
    assert!(!supports_tls("aaaa[qwer]tyui"));
    assert!(supports_tls("ioxxoj[asdfgh]zxcvbn"));
}

fn supports_ssl(ipv7_address: &str) -> bool {
    let mut inside_brackets = false;
    let mut found_aba: HashSet<(u8, u8)> = HashSet::new();
    let mut found_bab: HashSet<(u8, u8)> = HashSet::new();

    let bytes = ipv7_address.as_bytes();
    for i in 2..bytes.len() {
        if bytes[i] == b'[' {
            inside_brackets = true;
        } else if bytes[i] == b']' {
            inside_brackets = false;
        } else if bytes[i-2] == bytes[i] && bytes[i] != bytes[i-1] && bytes[i-1] != b'[' && bytes[i-1] != b']' {
            if inside_brackets {
                found_bab.insert((bytes[i-1], bytes[i]  ));
            } else {
                found_aba.insert((bytes[i]  , bytes[i-1]));
            }
        }
    }

    found_aba.intersection(&found_bab).count() > 0
}

#[test]
fn test_supports_ssl() {
    assert!(supports_ssl("aba[bab]xyz"));
    assert!(!supports_ssl("xyx[xyx]xyx"));
    assert!(supports_ssl("aaa[kek]eke"));
    assert!(supports_ssl("zazbz[bzb]cdb"));
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day7.txt").unwrap();
    let part1_count = puzzle_input.lines().filter(|addr| supports_tls(addr)).count();
    let part2_count = puzzle_input.lines().filter(|addr| supports_ssl(addr)).count();

    println!("Part 1 answer: {}", part1_count);
    println!("Part 2 answer: {}", part2_count);
}