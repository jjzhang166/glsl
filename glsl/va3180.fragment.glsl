#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Cotton
//mod nnorm

void main( void ) {

	vec2 position = gl_FragCoord.xy * 0.1;
	position.y *= 3.;
	
	float color = 0.0;
	color += sin(position.x + (cos(position.y+sin(abs(cos(time)-time)))));
	color -= mod(position.y + sqrt(position.x+time), cos(position.y+time));

	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}