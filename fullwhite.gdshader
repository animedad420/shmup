shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque, depth_prepass_alpha;

uniform sampler2D tex:source_color,filter_linear_mipmap,repeat_disable;
uniform vec3 flash_color:source_color = vec3(1.0);
uniform float intensity:hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	vec4 tex_color = texture(tex, UV);
	ALBEDO = mix(tex_color.rgb, flash_color, intensity);
	ALPHA = tex_color.a;
}