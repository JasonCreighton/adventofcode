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

fn decompress(compressed: &[u8]) -> Vec<u8> {
    let mut out = Vec::new();
    let mut ptr = compressed;

    while ptr.len() > 0 {
        if ptr[0] == b'(' {
            expect(&mut ptr, b'(');
            let length = read_number(&mut ptr);
            expect(&mut ptr, b'x');
            let times = read_number(&mut ptr);
            expect(&mut ptr, b')');
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

#[test]
fn test_decompress() {
    assert_eq!(decompress(b"ADVENT"), b"ADVENT");
    assert_eq!(decompress(b"A(1x5)BC"), b"ABBBBBC");
    assert_eq!(decompress(b"(3x3)XYZ"), b"XYZXYZXYZ");
    assert_eq!(decompress(b"A(2x2)BCD(2x2)EFG"), b"ABCBCDEFEFG");
    assert_eq!(decompress(b"(6x1)(1x3)A"), b"(1x3)A");
    assert_eq!(decompress(b"X(8x2)(3x3)ABCY"), b"X(3x3)ABC(3x3)ABCY");
}

pub fn run() {
    let puzzle_input = std::fs::read_to_string("inputs/day9.txt").unwrap();
    let bytes = puzzle_input.as_bytes();

    let part1_answer = decompress(bytes).len();

    println!("Part 1 answer: {}", part1_answer);
}