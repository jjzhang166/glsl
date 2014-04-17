#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define radius 0.5

void main( void ) {

	vec2 position = 1.25 * ( gl_FragCoord.xy / resolution.xy - vec2( 0.5, 0.5 ) );
	
	position.x = position.x / position.y / ( 2.0 * ( 0.5 + 0.499 * sin( time ) ) );
	
	float dis = length( position );
	if( dis > radius ) {
		discard;
	}
	
	float z = abs( radius * radius - position.x * position.x - position.y * position.y );
	
	vec3 normal = normalize( vec3( position.x, position.y, z ) );
	normal += fract( 10.0 * ( 0.5 + 0.45 * sin( time ) ) * normal );
	
	gl_FragColor = vec4( normal, 1.0 );

}