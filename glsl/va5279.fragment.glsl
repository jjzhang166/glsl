#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 color;
void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec3 color = vec3(sin(distance(position, mouse)*mod(time, 4.0) / 3.0) * 4.0, sin(distance(position, mouse)*mod(time, 1.3) / 0.4), sin(distance(position, mouse) * mod(time, 10.0) / 0.1));
	float dist = mod(distance(position, mouse), 10.0);
	
	if (dist*mod(time, 3.0) > 2.0) {
		dist /= 2.0;
		position *= 0.4;
	} else {
		dist *= 2.0;
		position /= 0.4;
	}
	
	if (dist < 3.0)
		color.r *= sin(mod(time*position.x, 3.5));
	else if (dist < 6.0)
		color.g *= sin(mod(time*position.y, 5.2));
	else if (dist < 9.0)
		color.b *= sin(mod(time/position.x, 0.4));
	else
		color.rbg *= sin(mod(dist*time, 4.0));
	
	gl_FragColor = vec4(color.r, color.g, color.b, 1.0);
}