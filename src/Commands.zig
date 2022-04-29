const std = @import("std");
const util = @import("Util.zig");

pub const DrawString = struct {
    text: std.ArrayList(u8),
    face: util.Face,
};

pub const DrawCommand = struct {
    menus: std.ArrayList(std.ArrayList(u8)),
};
