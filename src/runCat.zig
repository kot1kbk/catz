const std = @import("std");
const config = @import("config.zig");
const copyWithSendfile = @import("copyWithSendfile.zig").copyWithSendfile;

pub fn runCat(init: std.process.Init, config_flags: config.Config, file: []const u8) !void {
    const f = try std.Io.Dir.cwd().openFile(init.io, file, .{});
    defer f.close(init.io);
    const allocator = init.arena.allocator();

    const buf = try allocator.alloc(u8, 1024 * 1024 * 7);
    defer allocator.free(buf);

    var f_reader = f.reader(init.io, buf);
    const reader = &f_reader.interface;

    var line_no: usize = 1;

    const buf_out = try allocator.alloc(u8, 1024 * 1024 * 7);
    defer allocator.free(buf_out);

    var stdout_writer = std.Io.File.Writer.init(.stdout(), init.io, buf_out);
    const writer = &stdout_writer.interface;

    const need_process = config_flags.number or config_flags.end or config_flags.number_nonblank or config_flags.squeeze_blank;
    if (!need_process) {
        try copyWithSendfile(init, file);
        return;
    }

    var prev_empty = false;

    while (try reader.takeDelimiter('\n')) |line| {
        const is_empty = line.len == 0;

        if (config_flags.squeeze_blank and is_empty and prev_empty) {
            prev_empty = true;
            continue;
        }
        prev_empty = is_empty;

        if (config_flags.number_nonblank and !is_empty) {
            try writer.print("{:6}\t", .{line_no});
            line_no += 1;
        }
        if (config_flags.number and !config_flags.number_nonblank) {
            try writer.print("{:6}\t", .{line_no});
            line_no += 1;
        }

        try writer.print("{s}", .{line});

        if (config_flags.end) {
            try writer.print("$", .{});
        }

        try writer.writeByte('\n');
    }
    try stdout_writer.flush();
}
