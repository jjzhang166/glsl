#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float r = (1.0-gl_FragCoord.x/resolution.x + gl_FragCoord.y/resolution.y)/2.0;
	float g = sin((gl_FragCoord.x*0.01+time*5.0))*0.5;
	float b = (gl_FragCoord.x/resolution.x + 1.0-gl_FragCoord.y/resolution.y)/2.0;
	
	gl_FragColor = vec4(r, g, b, 1.0);
}