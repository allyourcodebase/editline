const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.createModule(.{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .sanitize_c = false,
    });
    lib_mod.addCSourceFiles(
        .{
            .files = &.{
                "src/editline.c",
                "src/complete.c",
                "src/sysunix.c",
            },
        },
    );

    const config_header = b.addConfigHeader(
        .{
            .style = .{
                .autoconf_undef = b.path("config.h.in"),
            },
        },
        .{
            .CLOSEDIR_VOID = null,
            .CONFIG_ANSI_ARROWS = 1,
            .CONFIG_EOF = 1,
            .CONFIG_SIGINT = 1,
            .CONFIG_SIGSTOP = null,
            .CONFIG_TERMINAL_BELL = null,
            .CONFIG_UNIQUE_HISTORY = 1,
            .CONFIG_USE_TERMCAP = null,
            .GWINSZ_IN_SYS_IOCTL = 1,
            .HAVE_DIRENT_H = 1,
            .HAVE_DLFCN_H = 1,
            .HAVE_INTTYPES_H = 1,
            .HAVE_LIBCURSES = null,
            .HAVE_LIBNCURSES = null,
            .HAVE_LIBTERMCAP = null,
            .HAVE_LIBTERMINFO = null,
            .HAVE_LIBTINFO = null,
            .HAVE_MALLOC_H = 1,
            .HAVE_NDIR_H = null,
            .HAVE_PERROR = 1,
            .HAVE_SGTTY_H = 1,
            .HAVE_SIGNAL_H = 1,
            .HAVE_STAT_EMPTY_STRING_BUG = null,
            .HAVE_STDINT_H = 1,
            .HAVE_STDIO_H = 1,
            .HAVE_STDLIB_H = 1,
            .HAVE_STRCHR = 1,
            .HAVE_STRDUP = 1,
            .HAVE_STRINGS_H = 1,
            .HAVE_STRING_H = 1,
            .HAVE_STRRCHR = 1,
            .HAVE_SYS_DIR_H = null,
            .HAVE_SYS_NDIR_H = null,
            .HAVE_SYS_STAT_H = 1,
            .HAVE_SYS_TYPES_H = 1,
            .HAVE_TCGETATTR = 1,
            .HAVE_TERMCAP_H = 1,
            .HAVE_TERMIOS_H = 1,
            .HAVE_TERMIO_H = 1,
            .HAVE_UNISTD_H = 1,
            .LSTAT_FOLLOWS_SLASHED_SYMLINK = 1,
            .LT_OBJDIR = ".libs/",
            .PACKAGE = "editline",
            .PACKAGE_BUGREPORT = "https://github.com/troglobit/editline/issues",
            .PACKAGE_NAME = "editline",
            .PACKAGE_STRING = "editline 1.17.1",
            .PACKAGE_TARNAME = "editline",
            .PACKAGE_URL = "",
            .PACKAGE_VERSION = "1.17.1",
            .STAT_MACROS_BROKEN = null,
            .STDC_HEADERS = 1,
            .SYS_UNIX = 1,
            .VERSION = "1.17.1",
            .size_t = null,
        },
    );
    lib_mod.addConfigHeader(config_header);

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "editline",
        .root_module = lib_mod,
    });

    lib.step.dependOn(&config_header.step);
    b.installArtifact(lib);
}
