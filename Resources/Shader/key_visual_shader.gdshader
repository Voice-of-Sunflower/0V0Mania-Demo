shader_type canvas_item;

uniform float light_strength: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 color = vec4(1.0);

	COLOR += color * light_strength;
}
