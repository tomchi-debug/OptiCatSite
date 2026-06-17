#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uTemperature;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    float temp = texture(uTemperature, uv).r;
    
    // Heatmap mapping: 15C (Blue) -> 20C (Green) -> 25C (Red)
    float normalizedTemp = (temp - 15.0) / 10.0;
    
    vec3 color;
    color.r = smoothstep(0.5, 1.0, normalizedTemp);
    color.g = smoothstep(0.0, 0.5, normalizedTemp) - smoothstep(0.5, 1.0, normalizedTemp);
    color.b = 1.0 - smoothstep(0.0, 0.5, normalizedTemp);

    fragColor = vec4(color, 0.5);
}
