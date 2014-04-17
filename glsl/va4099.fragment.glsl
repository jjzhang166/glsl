#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define radius 0.7

/*
 * A simple 3D sphere.
 */

void main( void ) {

	// Frag coord to corrected 0 to 1 coordinates with 0.5, 0.5 at center.
	float aspectRatio = resolution.x / resolution.y;
	vec2 position = 2.0 * ( ( gl_FragCoord.xy / resolution.xy ) - vec2( 0.5, 0.5 ) );
	position.x *= aspectRatio;
	
	// Discard fragments outside the circle.
	float dis = length( position );
	if( dis > radius ) {
		discard;
	}
	
	// Evaluate z.
	float z = sqrt( radius * radius - position.x * position.x - position.y * position.y );
	
	// Evaluate normal.
	vec3 normal = normalize( vec3( position.x, position.y, z ) );
	
	// Apply simple lighting.
	vec2 centeredMouse = mouse - vec2( 0.5, 0.5 );
	vec3 view = normalize( vec3( centeredMouse, 1 ) );
	float proj = dot( view, normal );
	
	// Out!
	gl_FragColor = vec4( vec3( proj ), 1.0 );

}