const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSafe });

    const exe = b.addExecutable(.{
        .name = "main",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibCpp();

    const raylib_zig = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });
    const raylib = raylib_zig.module("raylib");
    const raylib_math = raylib_zig.module("raylib-math");
    const raylib_artifact = raylib_zig.artifact("raylib");
    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raylib-math", raylib_math);

    const zgui = b.dependency("zgui", .{
        .shared = false,
        .with_implot = true,
    });
    exe.root_module.addImport("zgui", zgui.module("root"));
    exe.linkLibrary(zgui.artifact("imgui"));
    exe.addIncludePath(.{ .path = "vendor/zgui/libs/imgui" });

    const rlimgui = b.dependency("rlimgui", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addCSourceFile(.{
        .file = rlimgui.path("rlImGui.cpp"),
        .flags = &.{
        "-fno-sanitize=undefined",
        "-std=c++11",
        "-Wno-deprecated-declarations",
        "-DNO_FONT_AWESOME",
        },
    });
    exe.addIncludePath(rlimgui.path("."));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
