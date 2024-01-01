const std = @import("std");
const raylib = @import("raylib_zig");
const zgui = @import("zgui");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSafe });

    const raylib_zig = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = try raylib.setup(b, raylib_zig, .{
        .name = "main",
        .src = "src/main.zig",
        .target = target,
        .optimize = optimize,
        .createRunStep = true,
    });

    exe.linkLibCpp();

    const zgui_pkg = zgui.package(b, target, optimize, .{
        .options = .{ .backend = .no_backend },
    });
    zgui_pkg.link(exe);
    exe.addIncludePath(.{ .path = "vendor/zgui/libs/imgui" });

    const rlimgui_cflags = &.{
        "-fno-sanitize=undefined",
        "-std=c++11",
        "-Wno-deprecated-declarations",
        "-DNO_FONT_AWESOME",
    };
    const rlimgui = b.dependency("rlimgui", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addCSourceFile(.{
        .file = rlimgui.path("rlImGui.cpp"),
        .flags = rlimgui_cflags,
    });
    exe.addIncludePath(rlimgui.path("."));

    b.installArtifact(exe);
}
