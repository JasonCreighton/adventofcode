const PART1_PUZZLE_INPUT: [(i64, i64); 6] = [(7, 0), (13, 0), (3, 2), (5, 2), (17, 0), (19, 7)];
const PART2_PUZZLE_INPUT: [(i64, i64); 7] = [(7, 0), (13, 0), (3, 2), (5, 2), (17, 0), (19, 7), (11, 0)];

// Reduce a list of periods and phases to a single period and phase. (It is as
// if we reduce the problem to a single large disk, instead of multiple small
// disks)
fn find_common_period(periods: &[(i64, i64)]) -> (i64, i64) {
    let mut common_period = 1;
    let mut common_phase = 0;

    for &(period, phase) in periods {
        // Find some time t that satisfies both (t % period) == phase and (t % common_period) == common_phase
        let mut t = common_phase;
        while (t % period) != phase {
            t += common_period;
        }
        assert!((t % period) == phase);
        assert!((t % common_period) == common_phase);

        // Find common period and phase
        let lcm = common_period * period; // FIXME: This only works because all the input periods seem to be prime
        common_period = lcm;
        common_phase = t % lcm;
    }

    // Check final result against inputs
    for (period, phase) in periods {
        assert_eq!(common_period % period, 0);
        assert_eq!(common_phase % period, *phase);
    }

    (common_period, common_phase)
}

fn find_drop_time(periods: &[(i64, i64)]) -> i64 {
    let (period, phase) = find_common_period(periods);
    // If phase=0, then we could drop at time=0
    // But if phase=1, then we have to wait until time=period-1, and so on
    (period - phase) % period
}

// Adjust the initial positions for the fall time, so the rest of the code
// doesn't have to worry about it
fn adjust_for_fall_time(initial_positions: &[(i64, i64)]) -> Vec<(i64, i64)> {
    initial_positions
        .iter()
        .enumerate()
        .map(|(i, (num_positions, initial_position))| (*num_positions, (initial_position + (i as i64) + 1) % num_positions))
        .collect()
}

#[test]
fn test_example() {
    let periods = adjust_for_fall_time(&[(5, 4), (2, 1)]);
    let drop_time = find_drop_time(periods.as_slice());
    assert_eq!(drop_time, 5);
}

pub fn run() {
    let part1_periods = adjust_for_fall_time(&PART1_PUZZLE_INPUT);
    let part2_periods = adjust_for_fall_time(&PART2_PUZZLE_INPUT);

    println!("Part 1 answer: {}", find_drop_time(part1_periods.as_slice()));
    println!("Part 2 answer: {}", find_drop_time(part2_periods.as_slice()));
}