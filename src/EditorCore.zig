const std = @import("std");

pub const EditorCore = struct {
    alloc: std.mem.Allocator,
    pub fn init(alloc: std.mem.Allocator) EditorCore {
        return .{
            .alloc = alloc,
        };
    }
};
