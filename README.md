# editline

This is editline, packaged for Zig.

## How to use it

First, update your `build.zig.zon`:

```
zig fetch --save https://github.com/allyourcodebase/editline.git
```

Next, add this snippet to your `build.zig` script:

```zig
const editline_dep = b.dependency("editline", .{
    .target = target,
    .optimize = optimize,
});
your_compilation.linkLibrary(editline_dep.artifact("editline"));
```

This will provide a editline as a static library to `your_compilation`.

