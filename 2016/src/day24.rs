use std::collections::{HashMap, HashSet, VecDeque};

#[derive(Debug, Copy, Clone, PartialEq)]
enum Tile {
    Wall,
    Open,
    Location(u32),
}

fn parse_maze(puzzle_input: &str) -> Vec<Vec<Tile>> {
    puzzle_input.lines().map(|line|
        line.chars().map(|tile_char|
            match tile_char {
                '#' => Tile::Wall,
                '.' => Tile::Open,
                d if d.is_ascii_digit() => Tile::Location(d as u32 - '0' as u32),
                _ => panic!("Don't know what to do with '{}'", tile_char),
            }
        ).collect()
    ).collect()
}

fn all_locations(maze: &Vec<Vec<Tile>>) -> Vec<((i32, i32), u32)> {
    let mut locations: Vec<((i32, i32), u32)> = Vec::new();

    for (y, row) in maze.iter().enumerate() {
        for (x, &tile) in row.iter().enumerate() {
            if let Tile::Location(loc) = tile {
                locations.push(((x as i32, y as i32), loc));
            }
        }
    }

    locations
}

fn distances_from(starting_location: (i32, i32), maze: &Vec<Vec<Tile>>) -> HashMap<u32, u32> {
    let mut worklist: VecDeque<((i32, i32), u32)> = VecDeque::new();
    let mut visited: HashSet<(i32, i32)> = HashSet::new();
    let mut distances: HashMap<u32, u32> = HashMap::new();
    worklist.push_back((starting_location, 0));

    while let Some((position, depth)) = worklist.pop_front() {
        // Have we been here before?
        if visited.contains(&position) { continue; }
        visited.insert(position);

        // Did we find a location of interest?
        if let Tile::Location(loc) = maze[position.1 as usize][position.0 as usize] {
            distances.insert(loc, depth);
        }

        // Add possible moves to worklist
        for (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
            let new_position = (position.0 + dx, position.1 + dy);
            if new_position.0 < 0 || new_position.0 >= (maze[0].len() as i32) || new_position.1 < 0 || new_position.1 >= (maze.len() as i32) { continue; }
            if maze[new_position.1 as usize][new_position.0 as usize] == Tile::Wall { continue; }

            worklist.push_back((new_position, depth + 1));
        }
    }

    distances
}

fn shortest_tour(maze: &Vec<Vec<Tile>>, part2: bool) -> u32 {
    let locations = all_locations(maze);
    let mut distances: HashMap<(u32, u32), u32> = HashMap::new();

    // Build N^2 table of distances from each location to each location
    for &(coords, src_location_number) in &locations {
        for (dest_location_number, distance) in distances_from(coords, maze) {
            distances.insert((src_location_number, dest_location_number), distance);
        }
    }

    let possible_tours = permutations(&(1..(locations.len() as u32)).collect::<Vec<_>>());

    possible_tours.iter().map(|tour| {
        // Starting location is not included in the permuations, so need to
        // include distance from location 0 to the first stop on the tour.
        let mut dist: u32 = distances[&(0, tour[0])];

        for i in 0..tour.len()-1 {
            dist += distances[&(tour[i], tour[i+1])];
        }

        if part2 { dist += distances[&(*tour.last().unwrap(), 0)]; }

        dist
    }).min().unwrap()
}

fn permutations<T: Clone>(input: &[T]) -> Vec<Vec<T>> {
    if input.len() == 0 {
        vec![vec![]]
    } else {
        let mut results: Vec<Vec<T>> = Vec::new();

        for i in 0..input.len() {
            let elem = &input[i];
            let input_without_elem: Vec<T> = input.iter().enumerate().filter(|&(j, _)| j != i).map(|(_, x)| x.clone()).collect();
            let mut perms = permutations(&input_without_elem);
            for perm in &mut perms {
                perm.push(elem.clone());
            }

            results.extend(perms);
        }

        results
    }
}

#[test]
fn test_permutations() {
    let input: Vec<i32> = vec![1,2,3];
    let expected: Vec<Vec<i32>> = vec![vec![1,2,3], vec![1,3,2], vec![2,1,3], vec![2,3,1], vec![3,1,2], vec![3,2,1]];
    let mut perms = permutations(&input);
    perms.sort();
    assert_eq!(perms, expected);
}

#[test]
fn test_example() {
    let maze = parse_maze("\
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
");

    assert_eq!(shortest_tour(&maze, false), 14);
}

pub fn run() {
    let maze = parse_maze(&std::fs::read_to_string("inputs/day24.txt").unwrap());

    println!("Part 1 answer: {}", shortest_tour(&maze, false));
    println!("Part 2 answer: {}", shortest_tour(&maze, true));
}