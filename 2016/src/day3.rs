fn count_possible(triangles: &Vec<Vec<i32>>) -> i32 {
    let mut num_possible = 0;
    for triangle in triangles {
        let mut sorted_triangle = triangle.clone();
        sorted_triangle.sort();
        if (sorted_triangle[0] + sorted_triangle[1]) > sorted_triangle[2] {
            num_possible += 1;
        }
    }
    num_possible
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day3.txt").unwrap();
    let triangles = puzzle_input
        .lines()
        .map(|line| line
            .split_whitespace()
            .map(|s| s.parse().unwrap()).collect::<Vec<i32>>())
        .collect::<Vec<_>>();

    let mut transposed_triangles = Vec::new();
    for i in (0..triangles.len()).step_by(3) {
        for j in 0..3 {
            transposed_triangles.push(vec![triangles[i+0][j], triangles[i+1][j], triangles[i+2][j]]);
        }
    }

    println!("Part 1 answer: {}", count_possible(&triangles));
    println!("Part 2 answer: {}", count_possible(&transposed_triangles));
}