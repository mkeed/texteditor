const std = @import("std");
const util = @import("Util.zig");

pub const DrawString = struct {
    text: std.ArrayList(u8),
    face: util.Face,
    pub fn init(alloc: std.mem.Allocator) DrawString {
        return .{
            .text = std.ArrayList(u8),
            //.face = util.Face.

        };
    }
    pub fn deinit(self: *DrawString) void {
        self.text.deinit();
    }
};

pub const DrawCommand = struct {
    pub fn init(alloc: std.mem.Allocator) DrawCommand {
        return .{
            .alloc = std.mem.Allocator,
            .menus = std.ArrayList(DrawString).init(alloc),
        };
    }
    pub fn addMenu(self: *DrawCommand, text: DrawString) !void {
        try self.menus.append(text);
    }
    pub fn deinit(self: *DrawCommand) void {
        for (self.menus.items) |*item| {
            item.deinit();
        }
        self.menus.deinit();
    }
    alloc: std.mem.Allocator,
    menus: std.ArrayList(DrawString),
};
