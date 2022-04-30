const std = @import("std");
const Display = @import("Display.zig");
const cmds = @import("Commands.zig");
const ec = @import("EditorCore.zig");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    var disp = try Display.Display.init(alloc);
    defer disp.deinit();
    var cmd = cmds.DrawCommand.init(alloc);
    defer cmd.deinit();
    try cmd.addMenu("File");
    try disp.draw(cmd);
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
