shader_type canvas_item;

uniform bool enabled = false;
uniform vec4 overylay_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);


void fragment() {
	if (enabled) {
		float original_a = COLOR.a;
		vec4 replacement_clr = overylay_color;
		replacement_clr.a = original_a;
		COLOR = replacement_clr;
	}
}
