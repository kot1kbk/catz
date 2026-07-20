pub const Config = struct { help: bool = false, number: bool = false, end: bool = false, number_nonblank: bool = false, squeeze_blank: bool = false };

pub var global: Config = .{};
