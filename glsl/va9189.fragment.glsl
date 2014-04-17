#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float t= time/4.0;
	
	vec3 v= vec3(t, t+1.333, t+0.666);
	
	v= mod(v, 1.0);
	
	v.x+= gl_FragCoord.x/resolution.x;
	v.y+= gl_FragCoord.y/resolution.y;
	
	gl_FragColor = vec4( 1.0, 0.3765, 0.0314, mouse.y);
}