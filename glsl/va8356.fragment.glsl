#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	float z = 1.0 / abs(position.y);
	position.x *= resolution.x / resolution.y;
	position *= 50.0;
	float h = 0.0;
	h += sin(length(position + vec2(+10.0, 0.0)) * min(10.0, z)) * 1.0 / z + z;
	h += sin(length(position + vec2(-10.0, 0.0)) * min(10.0, z)) * 1.0 / z;
	h *= 0.5;
	gl_FragColor = vec4( vec3( h ), 1.0 );

}