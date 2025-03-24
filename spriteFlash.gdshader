shader_type canvas_item;

uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 flash_color = vec3(1.0, 1, 1); 
    vec4 tex = texture(TEXTURE, UV);
    vec4 glow = vec4(flash_color, tex.a) * flash_strength;
    COLOR = tex + glow; 

}

