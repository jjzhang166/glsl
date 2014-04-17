#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	/*
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
	*/

	// gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	// gl_FragColor = vec4(0, mod(gl_FragCoord.x / (resolution.x / 3.0), 1.0) * abs(max(sin(time), 0.5)), 0, 0);
	float r = 0.5;
	float g = 0.3;
	float b = 0.5;
	float rhk = 1. + ((1. / r - 1.) * min(time, 2. - time));
	float ghk = 1.;// + ((1. / g - 1.) * mod(time / 4., 0.4));
	float bhk = 1.;// + ((1. / b - 1.) * mod(time / 4., 0.4));
	if (time < 4.) {
	gl_FragColor = vec4(r * rhk, g * ghk, b * bhk, 0);
	}
}