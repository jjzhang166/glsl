#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


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
	
	
	
	if ( rand(vec2(mod(gl_FragCoord.x, 10.0)*time, mod(gl_FragCoord.y, 50.0)*time)) <=0.5)
		col.g += clamp(distance(mousePos, gl_FragCoord.xy)/1715.0, 0.0, 0.1);
		col.g = clamp(col.g, 0.0, 1.0);

	
	
	
	gl_FragColor = vec4(col,1.0);
}