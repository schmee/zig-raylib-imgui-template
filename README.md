# Zig + Raylib + ImGui = ❤️

Build things immediately with [Zig](https://www.ziglang.org), [Raylib](https://www.raylib.com/) and [ImGui](https://github.com/ocornut/imgui)!

## Build

1. Install [Zig 0.12.0](https://ziglang.org/download/) for your platform.
1. Clone this repo.
1. In the repo folder, run
    - `zig build run` for Debug build.
    - `zig build run -Drelease` for Release (Optimized) build.

## Info

This repo is a starter project for Raylib and ImGui, using [rlImGui](https://github.com/raylib-extras/rlImGui/) as the rendering backend for ImGui, and the [raylib-zig](https://github.com/Not-Nik/raylib-zig) and [zgui](https://github.com/zig-gamedev/zig-gamedev/tree/main/libs/zgui) bindings for Raylib and ImGui respectively. All the libraries are built from source and either vendored or provided through the Zig package manager.

The template has a single `main.zig` source file with a small example of how to use ImGui to control Raylib. If you're unsure where to start, try playing around with the existing code and maybe add a new ImGui controller for some Raylib parameter.

I hope this project is helpful for anyone who wants to get into these libraries who may not be familiar with the Zig build system or even Zig itself!

## Acknowledgements

This repo just glues other people's hard work together, so huge thanks and appreciation to the original authors:

- [Raylib](https://www.raylib.com/)
- [ImGui](https://github.com/ocornut/imgui)
- [raylib-zig](https://github.com/Not-Nik/raylib-zig)
- [zgui](https://github.com/zig-gamedev/zig-gamedev/tree/main/libs/zgui)
- [rlImGui](https://github.com/raylib-extras/rlImGui/)
