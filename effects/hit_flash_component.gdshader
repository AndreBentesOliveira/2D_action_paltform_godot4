shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque, depth_prepass_alpha;
// Remove unshaded if you want shading
// Replace cull_disabled if you want to only show one side (cull_front, cull_back)
// Reference for depth ::: https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html#render-modes

uniform bool active = false; // Sets pixels to flash color when true
uniform vec4 flash_color: source_color = vec4(1.0,1.0,1.0,1.0); // The color to use when active
uniform bool y_billboard = false; // Enables Y-Billboarding when true
uniform sampler2D tex: source_color; // A copy of the texture for the Sprite3D or AnimatedSprite3D 

void fragment() {
	vec4 col = texture(tex,UV);
	vec4 set_col = col;
	if(active == true) {
		set_col = flash_color;
	}
	ALBEDO = vec3(set_col.r,set_col.g,set_col.b);
	ALPHA = col.a;
}