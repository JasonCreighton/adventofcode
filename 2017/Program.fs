module Program

let runByNumber n =
    match n with
    | 1  -> Util.testDay n Day1.run
    | 2  -> Util.testDay n Day2.run
    | 3  -> Util.testDay n Day3.run
    | 4  -> Util.testDay n Day4.run
    | 5  -> Util.testDay n Day5.run
    | 6  -> Util.testDay n Day6.run
    | 7  -> Util.testDay n Day7.run
    | 8  -> Util.testDay n Day8.run
    | 9  -> Util.testDay n Day9.run
    | 10 -> Util.testDay n Day10.run
    | 11 -> Util.testDay n Day11.run
    | 12 -> Util.testDay n Day12.run
    | 13 -> Util.testDay n Day13.run
    | 14 -> Util.testDay n Day14.run
    | 15 -> Util.testDay n Day15.run
    | 16 -> Util.testDay n Day16.run
    | 17 -> Util.testDay n Day17.run
    | 18 -> Util.testDay n Day18.run
    | 19 -> Util.testDay n Day19.run
    | 20 -> Util.testDay n Day20.run
    | _ -> failwith "Invalid day"

let [<EntryPoint>] main _ =
    // Print out results. The actual development is done using xUnit, this is mainly
    // to have something we can run the profiler on.
    let numRuns = 3
    let numDays = 20

    for run = 1 to numRuns do
        let runTimer = System.Diagnostics.Stopwatch.StartNew()
        printfn "=== Run %d ===" run
        printfn "%3s %35s %35s %12s" "Day" "Part 1" "Part 2" "Time [ms]"
        for day = 1 to numDays do
            let dayTimer = System.Diagnostics.Stopwatch.StartNew()
            let (part1, part2) = runByNumber day
            dayTimer.Stop()
        
            printfn "%3d %35s %35s %12.1f" day part1 part2 dayTimer.Elapsed.TotalMilliseconds

        runTimer.Stop()
        printfn "Run time: %.1f [ms]" runTimer.Elapsed.TotalMilliseconds
        printfn ""
    0