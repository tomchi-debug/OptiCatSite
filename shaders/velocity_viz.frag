#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uVelocity; // RG = u,v velocity

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 vel = texture(uVelocity, uv).rg;
    
    // Normalize velocity for visualization (assuming max ~1.0 m/s for display range)
    float speed = length(vel);
    
    // Color mapping: Blue (low) -> Green -> Red (high)
    vec3 color = vec3(0.0);
    color.r = smoothstep(0.5, 1.0, speed);
    color.g = smoothstep(0.0, 0.5, speed) - smoothstep(0.5, 1.0, speed);
    color.b = 1.0 - smoothstep(0.0, 0.5, speed);

    // Add animated "streak" effect
    float streaks = sin(uv.x * 50.0 + vel.x * 10.0) * sin(uv.y * 50.0 + vel.y * 10.0);
    color += streaks * 0.1;

    fragColor = vec4(color, 0.6); // Semi-transparent overlay
}
