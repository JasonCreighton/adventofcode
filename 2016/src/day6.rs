use std::collections::HashMap;

fn extract_messages(puzzle_input: &str) -> (String, String) {
    let puzzle_lines: Vec<&str> = puzzle_input.lines().collect();
    let mut freq_by_position: Vec<HashMap<char, i32>> = (0..puzzle_lines[0].len()).map(|_| HashMap::new()).collect();

    for line in puzzle_lines {
        for (i, ch) in line.chars().enumerate() {
            *freq_by_position[i].entry(ch).or_insert(0) += 1;
        }
    }

    let mut part1_message = String::new();
    let mut part2_message = String::new();
    for freq in freq_by_position {
        part1_message.push(*freq.iter().max_by_key(|(_, count)| *count).unwrap().0);
        part2_message.push(*freq.iter().min_by_key(|(_, count)| *count).unwrap().0);
    }

    (part1_message, part2_message)    
}

#[cfg(test)]
const EXAMPLE_PUZZLE_INPUT: &str =
"eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar";

#[test]
fn test_extract_messages() {
    let (part1, part2) = extract_messages(EXAMPLE_PUZZLE_INPUT);
    assert_eq!(part1, "easter");
    assert_eq!(part2, "advent");
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day6.txt").unwrap();

    let (part1_message, part2_message) = extract_messages(&puzzle_input);

    println!("Part 1 answer: {}", part1_message);
    println!("Part 2 answer: {}", part2_message);
}