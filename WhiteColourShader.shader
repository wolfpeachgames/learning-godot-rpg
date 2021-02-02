shader_type canvas_item;

uniform bool active = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (active) {
		COLOR = COLOR + vec4(0.5, 0.5, 0.5, 0.0);
	}
}