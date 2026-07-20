const std = @import("std");
const runCat = @import("src/runCat.zig").runCat;
const config = @import("src/config.zig");
const help_text = @import("src/help.zig").help_text;

pub fn main(init: std.process.Init) !void {
    var args = try init.minimal.args.toSlice(init.arena.allocator());

    const allocator = init.arena.allocator();
    var file_list: std.ArrayList([]const u8) = .empty;
    defer file_list.deinit(allocator);

    for (args[1..]) |arg| {
        if (std.mem.startsWith(u8, arg, "-") or std.mem.startsWith(u8, arg, "--")) {
            if (std.mem.eql(u8, arg, "--help")) config.global.help = true;
            if (std.mem.eql(u8, arg, "-n") or std.mem.eql(u8, arg, "--number")) config.global.number = true;
            if (std.mem.eql(u8, arg, "-E") or std.mem.eql(u8, arg, "--show-ends")) config.global.end = true;
            if (std.mem.eql(u8, arg, "-b") or std.mem.eql(u8, arg, "--number-nonblank")) config.global.number_nonblank = true;
            if (std.mem.eql(u8, arg, "-s") or std.mem.eql(u8, arg, "--squeeze-blank")) config.global.squeeze_blank = true;
            continue;
        }
        try file_list.append(allocator, arg);
    }

    if (config.global.help) {
        std.debug.print("{s}\n", .{help_text});
        return;
    }

    if (file_list.items.len == 0) {
        std.debug.print("catz: use -help for information\n", .{});
        return;
    }

    for (file_list.items) |f| {
        runCat(init, config.global, f) catch |err| {
            if (err == error.FileNotFound) {
                std.debug.print("catz: cannot open file '{s}': No such file or directory\n", .{f});
            } else {
                std.debug.print("catz: cannot open file '{s}': error: {}\n", .{ f, err });
            }
        };
    }
}
