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

}