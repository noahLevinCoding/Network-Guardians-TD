shader_type canvas_item;

uniform float radius;
uniform vec2 position;

void fragment() {
	vec2 uv = UV;
	uv.x *= 1920.0;
	uv.y *= 1080.0;
	
	uv.x -= position.x;
	uv.y -= position.y;
	
    float dist = length(uv);
	float alpha_inv = 1.0;
	vec3 color = vec3(0.0);
	
	if (dist > radius) alpha_inv = 1.0;
	if (dist <= radius) alpha_inv = mix(0.0, 1.0, dist/radius);
	if (dist <= radius) alpha_inv *= alpha_inv;

	COLOR = vec4(color,1.0-alpha_inv);
}