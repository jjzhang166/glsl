#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5);
	float value = sin(1.0-distance(position,vec2(0,0))*32.0+time*8.0)*0.5+0.5;
	position.x+=cos(time/1.238374);
	float value2=sin(1.0-length(position)*32.0+time*8.0)*0.5+0.5;
	position.y+=sin(time/1.6756);
	float value3=sin(1.0-length(position)*32.0+time*8.0)*0.5+0.5;
	value;
	gl_FragColor = vec4(value3,value2-value3,value-length(value3+value2), 1.0 );

}