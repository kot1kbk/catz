const std = @import("std");
const linux = std.os.linux;

pub fn copyWithSendfile(init: std.process.Init, src_path: []const u8) !void {
    const src = try std.Io.Dir.cwd().openFile(init.io, src_path, .{});
    defer src.close(init.io);

    const stdout = std.Io.File.stdout();
    var offset: i64 = 0;
    const size = try src.length(init.io);

    while (offset < size) {
        const n = linux.sendfile(stdout.handle, src.handle, &offset, size - @as(usize, @intCast(offset)));
        if (n == 0) break;
        offset += @as(i64, @intCast(n));
    }
}
