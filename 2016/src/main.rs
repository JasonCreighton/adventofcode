mod day1;
mod day2;
mod day3;
mod day4;
mod day5;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let day : i32 = args[1].parse().unwrap();

    match day {
        1 => day1::run(),
        2 => day2::run(),
        3 => day3::run(),
        4 => day4::run(),
        5 => day5::run(),
        _ => println!("Day {} not implemented.", day),
    }
}
