const std = @import("std");


// does NOT include the header files, those seem to be magically included...
const c_src_files = [_][]const u8 {
    "src/main.c",
};


pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});


    const exe = b.addExecutable(.{
        .name = "zig-build-c-test",
        .target = target,
        .optimize = optimize,
    });


    exe.addCSourceFiles(.{
        .root = b.path("."),
        .files = &c_src_files,
    });
    exe.linkLibC();


    b.installArtifact(exe);


    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }


    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
