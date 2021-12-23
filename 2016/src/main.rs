mod day1;
mod day2;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let latest_day = 2;
    let day : i32 = args[1].parse().unwrap_or(latest_day);

    match day {
        1 => day1::run(),
        2 => day2::run(),
        _ => println!("Day {} not implemented.", day),
    }
}
