const PUZZLE_INPUT: u32 = 3005290;

fn steal_left(num_elves: u32) -> u32 {
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

// For this one we basically need O(1) random lookups and O(1) random
// removals. We use an array where we mark elves as removed, keeping track of
// how many we have removed, and periodically we compact the array.
fn steal_across(num_elves: u32) -> u32 {
    const ELF_REMOVED: u32 = u32::MAX;
    let mut elves: Vec<u32> = (1..=num_elves).collect();
    let mut removed_elves: usize = 0;
    let mut current_elf_index: usize = 0;

    loop {
        // Check if we are done
        let remaining_elves = elves.len() - removed_elves;
        if remaining_elves == 1 {
            return elves[current_elf_index];
        }

        // Remove an elf
        let across_index = (current_elf_index + (remaining_elves / 2) + removed_elves) % elves.len();
        assert_ne!(elves[across_index], ELF_REMOVED);
        elves[across_index] = ELF_REMOVED;
        removed_elves += 1;

        if elves[(current_elf_index + 1) % elves.len()] == ELF_REMOVED {
            // Our math for finding the elf across depends on there only being
            // removed elves between the current elf and the across elf. Once
            // the current index reaches a removed elf, it is time to compact
            // the array.
            let current_elf_number = elves[current_elf_index];
            elves.retain(|&e| e != ELF_REMOVED);
            removed_elves = 0;
            current_elf_index = elves.iter().position(|&e| e == current_elf_number).unwrap();
        }

        // Move to the next elf on the left
        current_elf_index = (current_elf_index + 1) % elves.len();
    }
}

#[test]
fn test_example() {
    assert_eq!(steal_left(5), 3);
    assert_eq!(steal_across(5), 2);
}

pub fn run() {
    println!("Part 1 answer: {}", steal_left(PUZZLE_INPUT));
    println!("Part 2 answer: {}", steal_across(PUZZLE_INPUT));
}