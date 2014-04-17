#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 xyZeroToOne = gl_FragCoord.xy/ resolution;
	float zeroToOneWave = sin( time ) * 0.5 + 0.5;
	
	float red = sin(xyZeroToOne.x + time * 5.0); 
	float green = cos(xyZeroToOne.y * time *5.0);
	float blue = sin( xyZeroToOne.y + time * 10.0);
	
	gl_FragColor = vec4( red*sin(time), green*10.0, blue, 100.0 );

}