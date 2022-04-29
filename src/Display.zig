const std = @import("std");
const util = @import("Util.zig");
const command = @import("Commands.zig");

pub const Display = struct {
    read_fds: [1]std.os.fd_t,
    orig: std.os.termios,
    size: util.Rect,
    print_buffer: std.ArrayList(u8),
    const in_fd = std.os.STDIN_FILENO;
    const out_fd = std.os.STDOUT_FILENO;
    pub fn init(alloc: std.mem.Allocator) !Display {
        if (!std.os.isatty(in_fd)) {
            return error.InvalidWindow;
        }
        const orig = try std.os.tcgetattr(out_fd);
        var raw = orig; //* modify the original mode */

        //* input modes: no break, no CR to NL, no parity check, no strip char,
        //* no start/stop output control. */
        raw.iflag &= ~(std.os.system.BRKINT | std.os.system.ICRNL | std.os.system.INPCK | std.os.system.ISTRIP | std.os.system.IXON);
        //* output modes - disable post processing */
        raw.oflag &= ~(std.os.system.OPOST);
        //* control modes - set 8 bit chars */
        raw.cflag |= (std.os.system.CS8);
        //* local modes - choing off, canonical off, no extended functions,
        //* no signal chars (^Z,^C) */
        raw.lflag &= ~(std.os.system.ECHO | std.os.system.ICANON | std.os.system.IEXTEN | std.os.system.ISIG);
        //* control chars - set return condition: min number of bytes and timer. */
        //raw.cc[6] = 0; //* Return each byte, or zero for timeout. */ //VMIN
        _ = try std.os.write(out_fd, "\x1b[?1049h");
        //* put terminal in raw mode after flushing */
        try std.os.tcsetattr(in_fd, .FLUSH, raw);

        return Display{
            .read_fds = .{in_fd},
            .orig = orig,
            .size = readScreenSize(in_fd),
            .print_buffer = std.ArrayList(u8).init(alloc),
        };
    }
    fn readScreenSize(fd: std.os.fd_t) util.Rect {
        var ws: std.os.system.winsize = undefined;
        return if (std.os.system.ioctl(fd, std.os.system.T.IOCGWINSZ, @ptrToInt(&ws)) == 0) .{
            .row = ws.ws_row,
            .col = ws.ws_col,
        } else .{
            .row = 0,
            .col = 0,
        };
    }

    const hide_cursor = "\x1b[?25L";
    const show_cursor = "\x1b[?25H";
    const go_to_base = "\x1b[H";
    const move_cursor = "\x1b[{};{}h"; //row,col
    pub fn draw(self: *Display, cmd: command.DrawCommand) !void {
        _ = cmd;
        self.print_buffer.clearRetainingCapacity();
        var writer = self.print_buffer.writer();
        try std.fmt.format(writer, "{s}{s}", .{ hide_cursor, go_to_base });
        //for (self.menus.items) |menu_item| {
        //try

        //}
    }

    pub fn deinit(self: *Display) void {
        std.os.tcsetattr(in_fd, .FLUSH, self.orig) catch {};
        self.print_buffer.deinit();
    }
};
