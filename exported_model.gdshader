shader_type spatial;
render_mode unshaded;

uniform vec4 flash_color: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform sampler2D albedo_tex:source_color, filter_linear_mipmap, repeat_disable;
uniform float intensity:hint_range(0.0, 1.0, 0.1) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(albedo_tex, UV);
	ALBEDO = mix(tex_color.rgb, flash_color.rgb, intensity);
	ALPHA = tex_color.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
