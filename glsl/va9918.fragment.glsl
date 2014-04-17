#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec3 col = vec3(0.0,0.0,0.0);
	
	//really light lines
	col.g += clamp(ceil(mod(gl_FragCoord.x, 10.0)) - 9.0, 0.0, 1.0) * 0.05;
	col.g += clamp(ceil(mod(gl_FragCoord.y, 10.0)) - 9.0, 0.0, 1.0) * 0.05;
	col.g = clamp(col.g, 0.0, 0.05);
	
	//light lines
	col.g += clamp(ceil(mod(gl_FragCoord.x, 50.0)) - 49.0, 0.0, 1.0) * 0.25;
	col.g += clamp(ceil(mod(gl_FragCoord.y, 50.0)) - 49.0, 0.0, 1.0) * 0.25;
	col.g = clamp(col.g, 0.0, 0.25);
	
	//strong lines
	col.g += clamp(ceil(mod(gl_FragCoord.x, 100.0)) - 99.0, 0.0, 1.0);
	col.g += clamp(ceil(mod(gl_FragCoord.y, 100.0)) - 99.0, 0.0, 1.0);
	col.g = clamp(col.g, 0.0, 1.0);
	
	//mouse detect
	vec2 mousePos = resolution.xy * mouse;
	col.g *= 1.0 - clamp(distance(mousePos, gl_FragCoord.xy)/175.0, 0.0, 1.0);
	
	
	gl_FragColor = vec4(col,1.0);
}