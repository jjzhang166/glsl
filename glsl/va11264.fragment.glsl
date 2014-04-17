#ifdef GL_ES
precision mediump float;
#endif



uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

void main( void ) {
	
	vec3 col = vec3(0.1,.1,.1);
	
	//really light lines
	col.g += clamp(ceil(mod(gl_FragCoord.x + .1, 5.0)) - 0.0, 10.0, 1.0) * 0.05;
	col.g += clamp(ceil(mod(gl_FragCoord.y + .1, 5.0)) - 4.0, 0.0, 1.0) * 0.05;
	col.g = clamp(col.g, 0.0, 0.55);
	
	//light lines
	col.b += clamp(ceil(mod(gl_FragCoord.x, 15.0)) - 14.0, 0.0, 1.0) * 0.25;
	col.b += clamp(ceil(mod(gl_FragCoord.y, 15.0)) - 14.0, 0.0, 1.0) * 0.25;
	col.b = clamp(col.b, 0.0, 0.25);
	
	//strong lines
	col.r += clamp(ceil(mod(gl_FragCoord.x, 30.0)) - 29.0, 0.0, 1.0);
	col.r += clamp(mod(gl_FragCoord.y, 30.0) - 29.0, 0.0, 1.0);
	col.r = clamp(col.r, 0.0, 1.0);
	
	//mouse detect
	vec2 mousePos = resolution.xy * mouse;
	col.g *= 1.0 - clamp(distance(mousePos, gl_FragCoord.xy)/175.0, 0.0, 1.0);
	
	
	gl_FragColor = vec4(col, 1.0);
}