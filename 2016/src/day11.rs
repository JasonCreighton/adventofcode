use std::collections::VecDeque;
use std::collections::HashMap;

const NUM_FLOORS: usize = 4;
const MAX_NUM_RTG_CHIP_PAIRS: usize = 7;

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
struct Position {
    elevator_floor: i8,
    item_floor: [i8; MAX_NUM_RTG_CHIP_PAIRS * 2],
}

impl Position {
    fn rtg_item(rtg_index: usize)   -> usize { (rtg_index  * 2) + 0 }
    fn chip_item(chip_index: usize) -> usize { (chip_index * 2) + 1 }

    fn any_chips_fried(&self, num_chip_pairs: usize) -> bool {
        // Find which floors are irradiated
        let mut floor_irradiated = [false; NUM_FLOORS];
        for i in 0..num_chip_pairs {
            floor_irradiated[self.item_floor[Self::rtg_item(i)] as usize] = true;
        }

        // Find if any chips are on an irradiated floor without their RTG
        for i in 0..num_chip_pairs {
            if self.item_floor[Self::chip_item(i)] != self.item_floor[Self::rtg_item(i)] && floor_irradiated[self.item_floor[Self::chip_item(i)] as usize] {
                return true;
            }
        }

        false
    }
}

// Find the minimum number of steps from the starting position to all reachable positions
fn find_min_steps_from(starting_position: Position, num_chip_pairs: usize) -> HashMap<Position, u32> {
    let mut worklist: VecDeque<(Position, u32)> = VecDeque::new();
    let mut min_steps_to: HashMap<Position, u32> = HashMap::new();
    worklist.push_back((starting_position, 0));

    while let Some((position, depth)) = worklist.pop_front() {
        // Have we been here before?
        if min_steps_to.contains_key(&position) { continue; }

        // We haven't, add it to the map
        min_steps_to.insert(position, depth);

        // Add any successor positions to the worklist
        for new_floor in [position.elevator_floor + 1, position.elevator_floor - 1] {
            if new_floor < 0 || new_floor >= (NUM_FLOORS as i8) { continue; }

            for item1 in 0..(num_chip_pairs * 2) {
                if position.item_floor[item1] != position.elevator_floor { continue; }

                for item2 in 0..(num_chip_pairs * 2) {
                    if position.item_floor[item2] != position.elevator_floor { continue; }

                    // At this point, we have two items on the same floor as
                    // the elevator. (or possibly just one item, with
                    // item1 == item2, which is intentionally allowed)
                    let mut new_position = position;

                    // Move elevator and items to the new floor
                    new_position.elevator_floor = new_floor;
                    new_position.item_floor[item1] = new_floor;
                    new_position.item_floor[item2] = new_floor;

                    // Did we fry anything?
                    if new_position.any_chips_fried(num_chip_pairs) { continue; }

                    // Finally, all okay, we can add it to the worklist
                    worklist.push_back((new_position, depth + 1));
                }
            }
        }
    }

    min_steps_to
}

// Puzzle input:
// The first floor contains a polonium generator, a thulium generator, a thulium-compatible microchip, a promethium generator, a ruthenium generator, a ruthenium-compatible microchip, a cobalt generator, and a cobalt-compatible microchip.
// The second floor contains a polonium-compatible microchip and a promethium-compatible microchip.
// The third floor contains nothing relevant.
// The fourth floor contains nothing relevant.
pub fn run() {
    let ending_position = Position {
        elevator_floor: (NUM_FLOORS - 1) as i8,
        item_floor: [(NUM_FLOORS - 1) as i8; MAX_NUM_RTG_CHIP_PAIRS * 2],
    };
    let mut starting_position = Position {
        elevator_floor: 0,
        item_floor: [0; MAX_NUM_RTG_CHIP_PAIRS * 2],
    };
    // Everything on the first floor (index 0) except for two microchips on the second floor (index 1)
    starting_position.item_floor[Position::chip_item(0)] = 1;
    starting_position.item_floor[Position::chip_item(1)] = 1;

    // Part 1 ending position has to be tweaked because the unused item slots
    // will stay at 0, and "ending_position" expects all items on the top floor.
    let mut part1_ending_position = ending_position;
    for i in 10..MAX_NUM_RTG_CHIP_PAIRS*2 { part1_ending_position.item_floor[i] = 0; }

    let part2_ending_position = ending_position;

    let part1_min_steps_to = find_min_steps_from(starting_position, 5);
    println!("Part 1 positions: {}", part1_min_steps_to.len());
    println!("Part 1 answer: {}", part1_min_steps_to[&part1_ending_position]);

    let part2_min_steps_to = find_min_steps_from(starting_position, 7);
    println!("Part 2 positions: {}", part2_min_steps_to.len());
    println!("Part 2 answer: {}", part2_min_steps_to[&part2_ending_position]);
}