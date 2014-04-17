#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float segment_lenght = 20.0;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	float center = resolution.y*0.5 + resolution.y*sin(time*4.0)*0.5;
	float r = 1.0 - abs((position.y - center)/segment_lenght);
	r += 1.0 - abs(position.x - resolution.x/2.0);
	gl_FragColor = vec4( r, 0, 0, 0 );

}