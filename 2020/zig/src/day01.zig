const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

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

    var answer: u32 = 0;
    outer: for (buffer[0..i]) |a, j| {
        for (buffer[(j+1)..i]) |b| {
            if (a + b == 2020) {
                answer = @as(u32, a) * b;
                break :outer;
            }
        }
    }

    print("{d}\n", .{answer});
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;
