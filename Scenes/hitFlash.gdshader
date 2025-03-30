shader_type canvas_item;

uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 white = vec4(1.0, 1.0, 1.0, tex.a);  // Pure white with original alpha
    COLOR = mix(tex, white, flash_strength);
}
