#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec4 colorVector = vec4(1,0,1,0);
	vec4 alphaVector = vec4(0,0,0,1);
	
	float x_position = gl_FragCoord.x;
	float y_position = gl_FragCoord.y;
	
	vec2 factor = (gl_FragCoord.y*mouse.y/resolution.xy)+(alphaVector.xy*mouse.x);
	
	gl_FragColor = colorVector*factor.x;
}