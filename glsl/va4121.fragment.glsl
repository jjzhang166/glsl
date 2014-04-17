#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 getCol(vec2 pos) {
	vec2 cartPos = pos * 2.0 - vec2(1.0);
	
	cartPos.x *= resolution.x / resolution.y;
	
	vec2 position = vec2(atan(cartPos.y, cartPos.x), length(cartPos));
	
	float width = abs(sin((position.x + time) * 0.5 + position.y * 15.0 * tan(time * 0.2))) * 0.3;
	
	float dist = abs(position.y - 0.5);
	
	if (abs(dist - width) < 0.05) {
		return vec3(1.0, 0.0, 0.0);
	} else {
		if (mod(position.x + time * 0.1, 0.1) < 0.02 && dist < width) {
			return vec3(width / 0.3);
		}
	}
	
	if (pos.y > 0.7 || pos.y < 0.3) {
		return vec3(0.1);
	}
	return vec3(pos.y * 0.2);

}

void main(void) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	
	vec3 color = getCol(pos);
	/* if (pos.y < 0.2) {
		vec2 refPos = pos;
		refPos.y = 0.4 - refPos.y;
		vec3 reflection = getCol(refPos);
		
		color = color * 0.4  + 0.6 * reflection;
		color *= 0.5;
	} */
	
	gl_FragColor = vec4(color, 1.0);
}