const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const editline_dep = b.dependency("editline-upstream", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.createModule(.{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .sanitize_c = false,
    });
    lib_mod.addCSourceFiles(.{
        .root = editline_dep.path("src"),
        .files = &.{ "editline.c", "complete.c", "sysunix.c" },
    });
    lib_mod.addIncludePath(editline_dep.path(""));

    const is_x86_linux = target.result.cpu.arch.isX86() and target.result.os.tag == .linux;
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "editline",
        .root_module = lib_mod,
        .use_llvm = !is_x86_linux,
    });

    const editline_dep_path_3 = editline_dep.path("").getPath3(b, null);

    editline_dep_path_3.access("config.h", std.fs.File.OpenFlags{}) catch |e| switch (e) {
        error.FileNotFound => {
            const command = b.fmt(
                "cd {s} && ./autogen.sh && ./configure",
                .{editline_dep_path_3.toString(b.allocator) catch @panic("OOM")},
            );
            const configure_step = b.addSystemCommand(&.{ "sh", "-c", command });
            lib.step.dependOn(&configure_step.step);
        },
        else => return e,
    };

    b.installArtifact(lib);
}
