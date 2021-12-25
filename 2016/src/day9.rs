fn expect(input: &mut &[u8], byte: u8) {
    if input[0] == byte {
        *input = &input[1..];
    } else {
        panic!("Unexpected input");
    }
}

fn read_number(input: &mut &[u8]) -> usize {
    let mut n = 0;
    while input[0] >= b'0' && input[0] <= b'9' {
        n *= 10;
        n += (input[0] - b'0') as usize;
        *input = &input[1..];
    }
    n
}

fn read_marker(ptr: &mut &[u8]) -> (usize, usize) {
    expect(ptr, b'(');
    let length = read_number(ptr);
    expect(ptr, b'x');
    let times = read_number(ptr);
    expect(ptr, b')');

    (length, times)
}

fn decompress(compressed: &[u8]) -> Vec<u8> {
    let mut out = Vec::new();
    let mut ptr = compressed;

    while ptr.len() > 0 {
        if ptr[0] == b'(' {
            let (length, times) = read_marker(&mut ptr);
            for _ in 0..times {
                out.extend_from_slice(&ptr[0..length]);
            }
            ptr = &ptr[length..];
        } else {
            out.push(ptr[0]);
            ptr = &ptr[1..];
        }
    }

    out
}

// Note that this is the part 2 algorithm, and is not expected to always give
// the same length that decompress() gives
fn decompressed_length(compressed: &[u8]) -> usize {
    let mut ptr = compressed;
    let mut prefix_length: usize = 0;

    while ptr.len() > 0 {
        if ptr[0] == b'(' {
            let (length, times) = read_marker(&mut ptr);
            return prefix_length + (decompressed_length(&ptr[0..length]) * times) + decompressed_length(&ptr[length..]);
        } else {
            prefix_length += 1;
            ptr = &ptr[1..];
        }
    }

    // If we get here, no marker found
    prefix_length
}

#[test]
fn test_decompress() {
    assert_eq!(decompress(b"ADVENT"), b"ADVENT");
    assert_eq!(decompress(b"A(1x5)BC"), b"ABBBBBC");
    assert_eq!(decompress(b"(3x3)XYZ"), b"XYZXYZXYZ");
    assert_eq!(decompress(b"A(2x2)BCD(2x2)EFG"), b"ABCBCDEFEFG");
    assert_eq!(decompress(b"(6x1)(1x3)A"), b"(1x3)A");
    assert_eq!(decompress(b"X(8x2)(3x3)ABCY"), b"X(3x3)ABC(3x3)ABCY");
}

#[test]
fn test_decompressed_length() {
    assert_eq!(decompressed_length(b"(3x3)XYZ"), 9);
    assert_eq!(decompressed_length(b"X(8x2)(3x3)ABCY"), 20);
    assert_eq!(decompressed_length(b"(27x12)(20x12)(13x14)(7x10)(1x12)A"), 241920);
    assert_eq!(decompressed_length(b"(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"), 445);
}

pub fn run() {
    let puzzle_input = std::fs::read("inputs/day9.txt").unwrap();

    let part1_answer = decompress(&puzzle_input).len();
    let part2_answer = decompressed_length(&puzzle_input);

    println!("Part 1 answer: {}", part1_answer);
    println!("Part 2 answer: {}", part2_answer);
}