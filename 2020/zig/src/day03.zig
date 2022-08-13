const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const tokenize = std.mem.tokenize;
const print = std.debug.print;
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

    var part_1 = count_trees(rows, 3, 1);
    print("Part 1: {}\n", .{part_1});

    var part_2 = count_trees(rows, 1, 1) * part_1 * count_trees(rows, 5, 1) * count_trees(rows, 7, 1) * count_trees(rows, 1, 2);

    print("Part 2: {}\n", .{part_2});
}

fn count_trees(slope: [][]bool, delta_x: usize, delta_y: usize) usize {
    var x: usize = 0;
    var y: usize = 0;
    var count: usize = 0;
    while (y < slope.len) {
        var square = slope[y][x];
        if (square) {
            count += 1;
        }
        x = std.math.mod(usize, x + delta_x, slope[y].len) catch 0;
        y += delta_y;
    }
    return count;
}
