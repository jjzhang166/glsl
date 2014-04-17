#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec4 position = vec4(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y, gl_FragCoord.z, 1.0);
	vec4 tint = vec4(sin(time),0.0,0.0,sin(time));
	
	vec4 result = position + tint;
	
	
	gl_FragColor = result;

}