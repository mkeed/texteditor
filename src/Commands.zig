const std = @import("std");
const util = @import("Util.zig");

pub const DrawString = struct {
    text: std.ArrayList(u8),
    face: util.Face,
    pub fn init(alloc: std.mem.Allocator) DrawString {
        return .{
            .text = std.ArrayList(u8).init(alloc),
            .face = util.Face.defaultFace(),
        };
    }
    pub fn deinit(self: *DrawString) void {
        self.text.deinit();
    }
};

pub const DrawLine = struct {
    lineNum: usize,
    text: std.ArrayList(u8),
};

pub const DrawCommand = struct {
    pub fn init(alloc: std.mem.Allocator) DrawCommand {
        return .{
            .alloc = alloc,
            .menus = std.ArrayList(std.ArrayList(u8)).init(alloc),
        };
    }
    pub fn deinit(self: *DrawCommand) void {
        for (self.menus.items) |*item| {
            item.deinit();
        }
        self.menus.deinit();
    }
    pub fn addLine(
        self: *DrawCommand,
        lineNum: usize,
        text: []const u8,
    ) !void {}
    alloc: std.mem.Allocator,
    lines: std.AutoHashMap(usize, std.ArrayList(u8)),
};
