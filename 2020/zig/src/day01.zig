const std = @import("std");
const tokenize = std.mem.tokenize;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;

const data = @embedFile("../data/day01.txt");

pub fn main() !void {
    var it = tokenize(u8, data, "\n");

    // Not sure if allocating a massive buffer and tracking the size is the right approach?
    var buffer: [1000]u16 = undefined;
    var i: usize = 0;
    while (it.next()) |line| {
        const int = try parseInt(u16, line, 10);
        buffer[i] = int;
        // Can we use continue expression?
        i = i + 1;
    }

    try part1(buffer[0..i]);
    try part2(buffer[0..i]);
}


fn part1(input: []u16) !void {
    for (input) |a, i| {
        for (input[(i+1)..]) |b| {
            if (a + b == 2020) {
                const answer = @as(u32, a) * b;
                print("Part1: {d}\n", .{answer});
                return;
            }
        }
    }
}

fn part2(input: []u16) !void {
    for (input) |a, i| {
        for (input[(i+1)..]) |b, j| {
            for (input[(j+1)..]) |c| {
                if (a + b + c == 2020) {
                    const answer = @as(u32, a) * b * c;
                    print("Part2: {d}\n", .{answer});
                    return;
                }
            }
        }
    }
}
