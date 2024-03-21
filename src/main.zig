const std = @import("std");
const print = std.debug.print;

const width = 10;
const height = 10;

const Rgb = struct {
    r: u32,
    g: u32,
    b: u32,
};

inline fn gen_01() [width * height]Rgb {
    comptime var data: [width * height]Rgb = undefined;

    @setEvalBranchQuota(height * width + width + 1);
    comptime var idx = 0;
    comptime var height_idx = 0;
    inline while (height_idx < height) : (height_idx += 1) {
        comptime var width_idx = 0;
        inline while (width_idx < width) : (width_idx += 1) {
            const g: u32 = @intFromFloat(255.999 * (@as(f32, @floatFromInt(height_idx)) / @as(f32, @floatFromInt(height))));
            const r: u32 = @intFromFloat(255.999 * (@as(f32, @floatFromInt(width_idx)) / @as(f32, @floatFromInt(width))));
            const b: u32 = 0;

            data[idx] = Rgb{ .r = r, .g = g, .b = b };
            idx += 1;
        }
    }

    return data;
}

const ppm_fmt = "P3\n{d} {d}\n255\n";
const fmt = "{d} {d} {d}\n";
fn gen_02(comptime data: *const [width * height]Rgb) u64 {
    comptime var counter = 0;
    inline for (data.*) |element| {
        const u = comptime std.fmt.count(fmt, .{ element.r, element.g, element.b });
        counter += u;
    } else {
        return counter + std.fmt.count(ppm_fmt, .{ width, height });
    }
}

fn gen_03(comptime data: *const [width * height]Rgb, comptime size: usize) [size:0]u8 {
    comptime var transformed_data: [size:0]u8 = undefined;
    const range = std.fmt.count(ppm_fmt, .{ width, height });
    @memcpy(transformed_data[0..range], std.fmt.comptimePrint(ppm_fmt, .{ width, height }));
    comptime var idx = range;
    inline for (data.*) |element| {
        const t = std.fmt.comptimePrint(fmt, .{ element.r, element.g, element.b });
        inline for (0..t.len) |i| {
            transformed_data[idx + i] = t[i];
        }
        idx += t.len;
    }
    return transformed_data;
}

pub fn main() !void {
    const data = gen_01();
    const size = comptime gen_02(&data);
    const transformed_data = comptime gen_03(&data, size);

    print("{s}", .{transformed_data});
}
