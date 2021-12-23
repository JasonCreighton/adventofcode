fn part1(puzzle_input: &str) -> i32 {
    let mut num_impossible = 0;
    for line in puzzle_input.lines() {
        let mut triangle = line.split_whitespace().map(|s| s.parse().unwrap()).collect::<Vec<i32>>();
        triangle.sort();
        if (triangle[0] + triangle[1]) <= triangle[2] {
            println!("Impossible: {:?}", triangle);
            num_impossible += 1;
        }
    }
    num_impossible
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day3.txt").unwrap();
    println!("Part 1 answer: {}", part1(&puzzle_input));
}