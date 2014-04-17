#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy);

	position *= 2.0;
	position -= vec2(1,1);
	
	float R = sin(position.x * PI + time);
	float B = cos(position.x * position.y * PI * time);
	float G = sin(position.y * PI - time);
	

	gl_FragColor = vec4( R,G,B, 1.0 );

}