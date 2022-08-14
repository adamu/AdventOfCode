const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const Map = std.AutoHashMap;
const StringHashMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const input = @embedFile("input");

pub fn main() !void {
    var line_it = split(u8, input, "\n");
    var passports = ArrayList(StringHashMap([]const u8)).init(gpa);
    var fields = StringHashMap([]const u8).init(gpa);
    while (line_it.next()) |line| {
        if (line.len == 0) {
            try passports.append(try fields.clone());
            fields.clearAndFree();
        } else {
            var token_it = tokenize(u8, line, " :");
            while (token_it.next()) |token| {
                try fields.put(token, token_it.next().?);
            }
        }
    }
    try passports.append(fields);

    const required_fields = [_][]const u8{ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
    var valid_count: usize = 0;
    for (passports.items) |passport| {
        var valid: bool = true;
        for (required_fields) |required_field| {
            valid = valid and passport.contains(required_field);
        }
        if (valid) valid_count += 1;
    }
    print("{}\n", .{valid_count});
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
