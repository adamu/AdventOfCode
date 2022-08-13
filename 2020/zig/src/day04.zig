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
    // *still* don't know how to manage the memory here...
    var passports = ArrayList([]const u8).init(gpa);
    var building_passport = ArrayList(u8).init(gpa);
    var prev: u8 = 'a';
    // Ugh. How do we split on a known string (not single byte)?
    for (input) |char| {
        if (prev == '\n' and char == '\n') {
            try passports.append(building_passport.toOwnedSlice());
        } else {
            try building_passport.append(char);
            prev = char;
        }
    }
    try passports.append(building_passport.toOwnedSlice());

    const required_fields = [_][]const u8{ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
    var valid_count: usize = 0;
    for (passports.items) |passport| {
        var tokens = tokenize(u8, passport, ": \n");
        var fields = StringHashMap(u8).init(gpa);
        while (tokens.next()) |token| {
            try fields.put(token, 1);
            _ = tokens.next();
        }
        var valid = true;
        for (required_fields) |required_field| {
            valid = valid and fields.contains(required_field);
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
