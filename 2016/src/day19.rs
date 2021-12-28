const PUZZLE_INPUT: u32 = 3005290;

fn elf_with_all_presents(num_elves: u32) -> u32 {
    let mut elf_left_index: Vec<u32> = (0..num_elves).map(|i| (i + 1) % num_elves).collect();
    let mut current_elf: u32 = 0;

    while elf_left_index[current_elf as usize] != current_elf {
        let left1 = elf_left_index[current_elf as usize];
        let left2 = elf_left_index[left1 as usize];

        // Remove "left1" from the linked list
        elf_left_index[current_elf as usize] = left2;
        current_elf = left2;
    }

    current_elf + 1 // 0 vs 1 indexing
}

#[test]
fn test_example() {
    assert_eq!(elf_with_all_presents(5), 3);
}

pub fn run() {
    println!("Part 1 answer: {}", elf_with_all_presents(PUZZLE_INPUT));
}