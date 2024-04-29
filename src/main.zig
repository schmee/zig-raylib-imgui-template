const std = @import("std");
const c = @cImport({
    @cDefine("NO_FONT_AWESOME", "1");
    @cInclude("rlImGui.h");
});
const rl = @import("raylib");
const z = @import("zgui");

pub fn main() !void {
    const screen_width = 1280;
    const screen_height = 600;

    rl.initWindow(screen_width, screen_height, "raylib / imgui demo");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    c.rlImGuiSetup(true);
    defer c.rlImGuiShutdown();

    z.initNoContext(std.heap.c_allocator);
    defer z.deinitNoContext();

    // Uncomment this to set a custom font for ImGui.
    // const font = z.io.addFontFromFile("fonts/Roboto-Medium.ttf", 20);
    // z.io.setDefaultFont(font);
    // c.rlImGuiReloadFonts();

    const background_color = rl.Color{ .r = 30, .g = 30, .b = 30, .a = 1 };
    const ball_color_default = [4]f32{ 190.0 / 255.0, 33.0 / 255.0, 55.0 / 255.0, 1 };
    const box_color_default = [4]f32{ 240.0 / 255.0, 240.0 / 255.0, 240.0 / 255.0, 1 };
    var ball_color = ball_color_default;
    var box_color = box_color_default;

    const speed_default: f32 = 5.0;
    const ball_position_default = rl.Vector2{ .x = screen_width / 4, .y = screen_height / 2 };
    const ball_speed_default = rl.Vector2{ .x = 4.0, .y = 5.0 };
    const ball_radius_default: i32 = 40;
    var speed = speed_default;
    var ball_position = ball_position_default;
    var ball_speed = ball_speed_default;
    var ball_radius = ball_radius_default;

    const rect_size_default: f32 = 1.0;
    var rect_size = rect_size_default;

    const camera_default = rl.Camera2D{
        .target = .{ .x = 0, .y = 0 },
        .offset = .{ .x = 0, .y = 0 },
        .rotation = 0.0,
        .zoom = 0.8,
    };
    var camera = camera_default;

    var prev_mouse_position = rl.getMousePosition();
    var capture = false;

    // Main loop
    while (!rl.windowShouldClose()) {
        // Game updates
        ball_speed.x = speed * std.math.sign(ball_speed.x);
        ball_speed.y = speed * std.math.sign(ball_speed.y);
        ball_position.x += ball_speed.x;
        ball_position.y += ball_speed.y;

        const rect = rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = screen_width / 2 * rect_size,
            .height = screen_height * rect_size,
        };

        // Low-effort clipping of the ball back into the rectangle
        const ball_radius_f: f32 = @floatFromInt(ball_radius);
        if (ball_position.x > rect.width or ball_position.y > rect.height) {
            ball_position.x -= ball_radius_f;
            ball_position.y -= ball_radius_f;
        }

        if ((ball_position.x <= rect.x + ball_radius_f) or (ball_position.x >= (rect.x + rect.width) - ball_radius_f))
            ball_speed.x *= -1;
        if ((ball_position.y <= rect.y + ball_radius_f) or (ball_position.y >= (rect.y + rect.height) - ball_radius_f))
            ball_speed.y *= -1;

        // Draw Raylib
        {
            rl.beginDrawing();
            defer rl.endDrawing();
            rl.clearBackground(background_color);

            {
                rl.beginMode2D(camera);
                defer rl.endMode2D();

                const line_thickness = 8;
                rl.drawRectangleLinesEx(rect, line_thickness, toRaylibColor(box_color));
                rl.drawCircleV(ball_position, @floatFromInt(ball_radius), toRaylibColor(ball_color));

                // Make sure to check that ImGui is not capturing the mouse inputs
                // before checking mouse inputs in Raylib!
                capture = z.io.getWantCaptureMouse();
                if (!capture) {
                    const mouse_position = rl.getMousePosition();
                    defer prev_mouse_position = mouse_position;

                    const zoom_delta = rl.getMouseWheelMove() * 0.01;
                    if (zoom_delta > 0 or (zoom_delta < 0 and camera.zoom > 0.05))
                        camera.zoom += zoom_delta;
                    if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_left)) {
                        const delta_x = mouse_position.x - prev_mouse_position.x;
                        const delta_y = mouse_position.y - prev_mouse_position.y;
                        camera.target = rl.Vector2{
                            .x = camera.target.x - delta_x,
                            .y = camera.target.y - delta_y,
                        };
                    }
                }
            }

            const strs = [_][:0]const u8{
                "Left button click and drag = pan camera",
                "Scroll wheel = zoom camera",
            };
            for (strs, 2..) |str, i| {
                const font_size = 24;
                const text_size = rl.measureTextEx(rl.getFontDefault(), str, @floatFromInt(font_size), 1);
                const width: i32 = @divFloor(screen_width - @as(i32, @intFromFloat(text_size.x)), 2);
                const height = screen_height - @as(i32, @intFromFloat(text_size.y)) * @as(i32, @intCast(i));
                rl.drawText(str, width, height, font_size, rl.Color.red);
            }
            rl.drawFPS(10, screen_height - 30);

            // Draw ImGui
            {
                c.rlImGuiBegin();
                defer c.rlImGuiEnd();

                var open = true;
                z.setNextWindowCollapsed(.{ .collapsed = true, .cond = .first_use_ever });
                z.showDemoWindow(&open);

                const imgui_width: f32 = screen_width / 3;
                const imgui_height: f32 = screen_height / 2;
                z.setNextWindowPos(.{ .x = screen_width / 2, .y = screen_height / 2 - 200 });
                z.setNextWindowSize(.{ .w = imgui_width, .h = imgui_height });

                _ = z.begin("Demo", .{});
                defer z.end();
                if (z.collapsingHeader("Settings", .{ .default_open = true })) {
                    if (z.button("Reset", .{})) {
                        ball_color = ball_color_default;
                        box_color = box_color_default;
                        speed = speed_default;
                        ball_position = ball_position_default;
                        ball_speed = ball_speed_default;
                        ball_radius = ball_radius_default;
                        rect_size = rect_size_default;
                        camera = camera_default;
                    }
                    z.separatorText("Color");
                    _ = z.colorEdit3("Ball", .{ .col = @ptrCast(&ball_color) });
                    _ = z.colorEdit3("Box", .{ .col = @ptrCast(&box_color) });
                    z.separatorText("Properties");
                    _ = z.sliderFloat("Box size", .{ .v = &rect_size, .min = 0, .max = 2 });
                    _ = z.sliderFloat("Speed", .{ .v = &speed, .min = 0, .max = 20 });
                    _ = z.sliderInt("Radius", .{ .v = &ball_radius, .min = 5, .max = 100 });
                }
            }
        }
    }
}

fn toRaylibColor(col: [4]f32) rl.Color {
    return .{
        .r = @intFromFloat(col[0] * 255),
        .g = @intFromFloat(col[1] * 255),
        .b = @intFromFloat(col[2] * 255),
        .a = @intFromFloat(col[3] * 255),
    };
}
