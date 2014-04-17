#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0-0.5);
	float value = sin(1.0-mouse.y-distance(position,vec2(0,0))*32.0+time*8.0)*0.5+0.5+mouse.x;
	
	gl_FragColor = vec4(value,value,value, 1.0 );

}