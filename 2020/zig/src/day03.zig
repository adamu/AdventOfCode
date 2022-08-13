const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("input");

pub fn main() !void {

    // Still have no idea how to clean up the ArrayLists
    var it = tokenize(u8, data, "\n");
    var rows_al = ArrayList([]bool).init(gpa);
    while (it.next()) |line| {
        var row = ArrayList(bool).init(gpa);
        for (line) |char| {
            try row.append(char == '#');
        }
        try rows_al.append(row.toOwnedSlice());
    }
    var rows = rows_al.toOwnedSlice();

    var x: usize = 0;
    var y: usize = 0;
    var count: usize = 0;
    while (y < rows.len) {
        var square = rows[y][x];
        if (square) {
            count += 1;
        }
        x = try std.math.mod(usize, x + 3, rows[y].len);
        y += 1;
    }
    print("{}", .{count});
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
