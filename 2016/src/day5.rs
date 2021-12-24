pub fn run() {
    let puzzle_input = "ffykfhsq";
    let mut n : u64 = 0;
    let mut part1_password = String::new();
    let mut part2_bytes = vec![b'_'; 8];

    loop {
        let digest = md5::compute(format!("{}{}", puzzle_input, n).as_bytes());
        if digest[0] == 0 && digest[1] == 0 && (digest[2] >> 4) == 0 {
            let hex_md5sum = format!("{:x}", digest);

            if part1_password.len() < 8 {
                part1_password.push(hex_md5sum.chars().nth(5).unwrap());
            }

            let position = digest[2] & 0xF;
            if position < 8 && part2_bytes[position as usize] == b'_' {
                part2_bytes[position as usize] = (hex_md5sum.chars().nth(6).unwrap() as u8);
            }

            println!("Found hash: {} (n = {:10}) part1: {:8} part2: {}", hex_md5sum, n, part1_password, String::from_utf8(part2_bytes.clone()).unwrap());

            if part1_password.len() == 8 && !part2_bytes.contains(&b'_') {
                // Done with both passwords
                break;
            }
        }
        n += 1;
    }
}