use regex::Regex;

fn flatten_coords(width: usize, height: usize, x: usize, y: usize) -> usize {
    assert!(x < width);
    assert!(y < height);
    (y * width) + x
}

fn rect(screen: &Vec<bool>, width: usize, height: usize, rect_width: usize, rect_height: usize) -> Vec<bool> {
    let mut new_screen = screen.clone();
    for x in 0..rect_width {
        for y in 0..rect_height {
            new_screen[flatten_coords(width, height, x, y)] = true;
        }
    }
    new_screen
}

fn rotate_column(screen: &Vec<bool>, width: usize, height: usize, x: usize, down_amount: usize) -> Vec<bool> {
    let mut new_screen = screen.clone();
    for y in 0..height {
        new_screen[flatten_coords(width, height, x, y)] = screen[flatten_coords(width, height, x, (y + height - down_amount) % height)];
    }
    new_screen
}

fn rotate_row(screen: &Vec<bool>, width: usize, height: usize, y: usize, right_amount: usize) -> Vec<bool> {
    let mut new_screen = screen.clone();
    for x in 0..width {
        new_screen[flatten_coords(width, height, x, y)] = screen[flatten_coords(width, height, (x + width - right_amount) % width, y)];
    }
    new_screen
}

fn screen_as_string(screen: &Vec<bool>, width: usize, height: usize) -> String {
    let mut ascii_screen = String::new();
    for y in 0..height {
        for x in 0..width {
            ascii_screen.push(if screen[flatten_coords(width, height, x, y)] { '#' } else { '.' });
        }
        ascii_screen.push('\n');
    }
    ascii_screen
}

#[test]
fn test_example() {
    const EXPECTED_FINAL_STATE: &str = "\
.#..#.#
#.#....
.#.....
";
    let width = 7;
    let height = 3;
    let screen0 = vec![false; width * height];
    let screen1 = rect(&screen0, width, height, 3, 2);
    let screen2 = rotate_column(&screen1, width, height, 1, 1);
    let screen3 = rotate_row(&screen2, width, height, 0, 4);
    let screen4 = rotate_column(&screen3, width, height, 1, 1);

    assert_eq!(screen_as_string(&screen4, width, height), EXPECTED_FINAL_STATE);
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day8.txt").unwrap();
    let width = 50;
    let height = 6;
    let mut screen = vec![false; width * height];
    let re_rect = Regex::new(r"^rect ([0-9]+)x([0-9]+)$").unwrap();
    let re_rotate = Regex::new(r"^rotate (row|column) [xy]=([0-9]+) by ([0-9]+)$").unwrap();

    for line in puzzle_input.lines() {
        if let Some(captures) = re_rect.captures(line) {
            let rect_width: usize = captures[1].parse().unwrap();
            let rect_height: usize = captures[2].parse().unwrap();
            screen = rect(&screen, width, height, rect_width, rect_height);
        } else if let Some(captures) = re_rotate.captures(line) {
            let row_or_column = &captures[1];
            let x_or_y: usize = captures[2].parse().unwrap();
            let rotate_amount: usize = captures[3].parse().unwrap();
            if row_or_column == "row" {
                screen = rotate_row(&screen, width, height, x_or_y, rotate_amount);
            } else if row_or_column == "column" {
                screen = rotate_column(&screen, width, height, x_or_y, rotate_amount);
            } else {
                panic!("Expected 'row' or 'column'");
            }
        }
    }

    let num_pixels_lit = screen.iter().filter(|pix_lit| **pix_lit).count();

    println!("Part 1 answer: {}", num_pixels_lit);

    println!("Part 2 answer:");
    print!("{}", screen_as_string(&screen, width, height));

}