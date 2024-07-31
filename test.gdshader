shader_type canvas_item;

uniform vec4 color_a : source_color;
uniform vec4 color_b : source_color;
uniform float threshold : hint_range(0.0, 100.0);

void fragment() {
    float min_distance = 999999.0; // Large number to start with

    // Fragment coordinate in local space
    vec2 frag_coord = FRAGCOORD.xy;

    // Retrieve the vertex positions from the UV coordinates (assuming UVs are set up correctly)
    vec2 vertex_positions[2];
    vertex_positions[0] = vec2(UV.x, 0.0);
    vertex_positions[1] = vec2(UV.x, 1.0);

    // Calculate the distance from the fragment to each vertex in local space
    for (int i = 0; i < 2; i++) {
        float distance = abs(frag_coord.y - vertex_positions[i].y);
        if (distance < min_distance) {
            min_distance = distance;
        }
    }

    // Normalize the distance and use it to blend between the two colors
    float factor = smoothstep(0.0, threshold, min_distance);

    // Interpolate between color_a and color_b based on the factor
    COLOR = mix(color_b, color_a, factor);
}
