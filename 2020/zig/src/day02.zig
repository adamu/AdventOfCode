const std = @import("std");
const gpa = @import("util.zig").gpa;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const tokenize = std.mem.tokenize;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;

const data = @embedFile("input");

const Rule = struct {
    a: u8, b: u8, char: u8, password: []const u8
};

pub fn main() !void {
    const rules = try parse();
    defer Allocator.free(gpa, rules);
    print("Part 1: {d}\n", .{part1(rules)});
    print("Part 2: {d}\n", .{part2(rules)});
}


fn parse() ![]Rule {
    var it = tokenize(u8, data, "\n");
    var rules = ArrayList(Rule).init(gpa);
    while (it.next()) |line| {
        var line_it = tokenize(u8, line, ": -");
        const a = try parseInt(u8, line_it.next().?, 10);
        const b = try parseInt(u8, line_it.next().?, 10);
        const char = line_it.next().?[0];
        const password = line_it.next().?;
        try rules.append(Rule{.a = a, .b = b, .char = char, .password = password});
    }
    return rules.toOwnedSlice();
}

fn part1(rules: []Rule) u16 {
    var valid_pw_count: u16 = 0;
    for (rules) |rule| {
        var count: u8 = 0;
        for (rule.password) |password_char| {
            if (rule.char == password_char)
                count += 1; 
        }

        if (rule.a <= count and count <= rule.b)
            valid_pw_count += 1;
    }
    return valid_pw_count;
}

fn part2(rules: []Rule) u16 {
    var valid_pw_count: u16 = 0;
    for (rules) |rule| {
        const a_match = rule.password[rule.a-1] == rule.char;
        const b_match = rule.password[rule.b-1] == rule.char;
        // No xor in zig?
        if (a_match and !b_match or !a_match and b_match)
            valid_pw_count += 1;
    }
    return valid_pw_count;
}
