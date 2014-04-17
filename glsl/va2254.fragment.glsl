#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5);
	position=0.01*floor(position*100.);
	float value = sin(1.0-distance(position,vec2(sin(atan(position.y, position.x)+time),sin(time+atan(time, position.y))))*32.0+time*8.0)*0.5+0.5;
	value=0.255*floor(value*255.);
	gl_FragColor = vec4(value,1.0-value,0, 1.0 );

}