#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define radius 0.23

/*
 * Same as last example but sphere moves with mouse, light stays at the center.
 */

void main( void ) {

	// FragCoord to corrected 0 to 1 coordinates.
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	// Correct aspect ratio.
	float aspectRatio = resolution.x / resolution.y;
	position.x *= aspectRatio;
	vec2 cMouse = mouse;
	cMouse.x *= aspectRatio;
	
	// Distance to mouse.
	vec2 fromMouse = position - cMouse;
	float distanceToMouse = length( fromMouse );
	
	// Discard fragments outside the circle.
	if( distanceToMouse > radius ) {
		discard;
	}
	
	// Evaluate z.
	float z = sqrt( radius * radius - fromMouse.x * fromMouse.x - fromMouse.y * fromMouse.y );
	
	// Evaluate normal.
	vec3 normal = normalize( vec3( fromMouse.x, fromMouse.y, z ) );
	
	// Apply simple lighting.
	vec3 view = normalize( vec3( -cMouse.x + 1.0, -cMouse.y + 0.5, 1.0 ) );
	float proj = dot( view, normal );
	
	// Out!
	gl_FragColor = vec4( vec3( proj ), 1.0 );
	//gl_FragColor = vec4( normal, 1.0 );

}