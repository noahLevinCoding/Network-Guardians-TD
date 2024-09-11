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
	float col = 0.0;
	float alpha = 1.0;
	
	if (dist > radius) alpha = 0.0;
	if (dist <= radius) alpha = smoothstep(1.0, 0.4, dist / radius);
	if (dist <= radius) col = smoothstep(0.0, 1.8, dist / radius);
	
	COLOR = vec4(vec3(col),alpha);
}