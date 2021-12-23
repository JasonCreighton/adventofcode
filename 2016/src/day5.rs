pub fn run() {
    let puzzle_input = "ffykfhsq";
    let mut n : u64 = 0;
    let mut password = String::new();

    while password.len() < 8 {
        let hex_md5sum = format!("{:x}", md5::compute(format!("{}{}", puzzle_input, n).as_bytes()));
        if hex_md5sum.starts_with("00000") {
            println!("Found hash: {} (n = {})", hex_md5sum, n);
            password.push(hex_md5sum.chars().nth(5).unwrap());
        }
        n += 1;
    }

    println!("Part 1 answer: {}", password);
}