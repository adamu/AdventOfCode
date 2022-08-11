const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("input");

pub fn main() !void {
    var it = tokenize(u8, data, "\n");
    var valid_pw_count: u16 = 0;
    while (it.next()) |line| {
        var line_it = tokenize(u8, line, ": -");
        const min_val = try parseInt(u8, line_it.next().?, 10);
        const max_val = try parseInt(u8, line_it.next().?, 10);
        const req_char = line_it.next().?[0];
        const password = line_it.next().?;

        // count how many times req_char is in password
        var count: u8 = 0;
        for (password) |password_char| {
            if (req_char == password_char)
                count += 1; 
        }

        if (min_val <= count and count <= max_val)
            valid_pw_count += 1;

        print("{d}-{d} {c}: {s} => {d}\n", .{min_val, max_val, req_char, password, count});
    }
    print("{d}\n", .{valid_pw_count});
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
