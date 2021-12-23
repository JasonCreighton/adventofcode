mod day1;
mod day2;
mod day3;

fn main() {
    let latest_day = 3;
    let args: Vec<String> = std::env::args().collect();
    let day : i32 = args[1].parse().unwrap_or(latest_day);

    match day {
        1 => day1::run(),
        2 => day2::run(),
        3 => day3::run(),
        _ => println!("Day {} not implemented.", day),
    }
}
