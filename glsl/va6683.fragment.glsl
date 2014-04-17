#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	float aspect = resolution.x / resolution.y;
	position *= 220.0 * sin (time);
	position.x *= aspect;
	float color = 1.0;
	color += sin( (length (position )- (time) * 20.0) )  ;
	gl_FragColor = vec4( vec3( color * 1. -  sin (time*4.), color * 1. + sin (time*6.),color * 1. + sin (time*12.)), 1.0 );
	//gl_FragColor = vec4( vec3( color * 1., color * 1. , color * 1.), 1.0 );
}