shader_type canvas_item;

uniform float radius;
uniform vec2 position;
uniform vec3 color : source_color = vec3(1.0);

void fragment() {
	vec2 uv = UV;
	uv.x *= 1920.0;
	uv.y *= 1080.0;
	
	uv.x -= position.x;
	uv.y -= position.y;
	
    float dist = length(uv);
	float alpha = 0.8;
	
	if (dist > radius) alpha = 0.0;
	if (dist <= radius) alpha = mix(0.05, 0.95, dist/radius);
	if (dist <= radius) alpha *= alpha;

	COLOR = vec4(color,alpha);
}
