# Zig + Raylib + ImGui = ❤️

Start building things immediately with [Zig](https://www.ziglang.org), [Raylib](https://www.raylib.com/) and [ImGui](https://github.com/ocornut/imgui)!

## Build

1. Install the latest [Zig master](https://ziglang.org/download/) for your platform.
1. Clone this repo.
1. In the repo folder, run
    - `zig build run` for Debug build.
    - `zig build run -Drelease` for Release (Optimized) build.

## Info

This repo is a starter project for Raylib and ImGui, using [rlImGui](https://github.com/raylib-extras/rlImGui/) as the rendering backend for ImGui, and the [raylib.zig](https://github.com/ryupold/raylib.zig) and [zgui](https://github.com/zig-gamedev/zig-gamedev/tree/main/libs/zgui) bindings for Raylib and ImGui respectively. All the libraries are built from source and either vendored or provided through the Zig package manager.

It targets both users who are unfamiliar with any of Zig, Raylib and ImGui and who want a quick and easy way to get started, without the complication of buiding several C libraries from source, as well experienced users who want to save themselves the trouble of putting together the `build.zig` for all these libraries.

The template has a single `main.zig` source file with a small example of how to use ImGui to control Raylib. If you're unsure where to start, try playing around with the existing code, and maybe add a new ImGui controller for some Raylib parameter.

I hope this project is helpful for anyone who wants to get into these libraries who may not be familiar with the Zig build system or even Zig itself!

_NOTE: The template uses [a branch of raylib.zig](https://github.com/ryupold/raylib.zig/pull/38) that adds Zig package manager support until that gets merged into main._

## Acknowledgements

This repo just glues other people's hard work together, so huge thanks and appreciation to the original authors:

- [Raylib](https://www.raylib.com/)
- [ImGui](https://github.com/ocornut/imgui)
- [raylib.zig](https://github.com/ryupold/raylib.zig)
- [zgui](https://github.com/zig-gamedev/zig-gamedev/tree/main/libs/zgui)
- [rlImGui](https://github.com/raylib-extras/rlImGui/)
