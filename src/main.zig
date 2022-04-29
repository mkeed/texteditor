const std = @import("std");
const Display = @import("Display.zig");
const cmds = @imports("Commands.zig");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();
    var disp = Display.init(alloc);
    defer disp.deinit();
    var cmd = cmds.DrawCommand{};
    disp.draw();
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
