const std = @import("std");
const print = std.debug.print;

const width = 256;
const height = 256;

const Rgb = struct {
    r: u8,
    g: u8,
    b: u8,
    fn init(r: u8, g: u8, b: u8) Rgb {
        return Rgb{ .r = r, .g = g, .b = b };
    }
};

fn xpto(comptime size: u32) type {
    var data: [size]Rgb = {};
    var i = 0;
    while (i < size) : (i += 1) {
        data[i] = Rgb{ 255, 255, 255 };
    }

    return @TypeOf("wasd");
}

pub fn main() !void {
    const foo = Rgb{ 255, 255, 0 };
    print("r:{d} g:{d} b:{d} {s}", .{ foo.r, foo.g, foo.b, @typeName(@TypeOf("wasd"[0..])) });
}
