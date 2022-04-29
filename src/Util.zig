const std = @import("std");

pub const Color = struct {
    red: u8,
    green: u8,
    blue: u8,
    pub fn write(self: Face, writer: anytype, foreground: bool) !void {}
};

pub const Face = struct {
    pub const boldVal = [2][]const u8{ "\x1b[1m", "\x1b[22m" };
    pub const italicVal = [2][]const u8{ "\x1b[3m", "\x1b[23m" };
    pub const underlineVal = [2][]const u8{ "\x1b[4m", "\x1b[24m" };
    pub const strikeVal = [2][]const u8{ "\x1b[9m", "\x1b[29m" };
    pub const overlineVal = [2][]const u8{ "\x1b[53m", "\x1b[55m" };
    fg: Color,
    bg: Color,
    bold: bool,
    italic: bool,
    underline: bool,
    strike: bool,
    overline: bool,
    pub fn write(self: Face, writer: anytype) !void {
        const bold = if (self.bold) @as(u1, 1) else @as(u1, 0);
        const italic = if (self.italic) @as(u1, 1) else @as(u1, 0);
        const underline = if (self.underline) @as(u1, 1) else @as(u1, 0);
        const strike = if (self.strike) @as(u1, 1) else @as(u1, 0);
        const overline = if (self.bold) 1 else 0;
        try std.fmt.format("{s}{s}{s}{s}{s}{s}{s}", .{
            boldVal[bold],
            italicVal[italic],
            underlineVal[underline],
            strikeVal[strike],
            overlineVal[overline],
        });
    }
};

pub const Rect = struct {
    col: usize,
    row: usize,
};
