#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 centres[100];

/*
 * Metaballs 102.
 * Author: Someone trying to learn this stuff.
 */

float metaballContribution( vec2 position, vec2 center ) {	
	vec2 delta = position - center;
	return 1.0 / ( delta.x * delta.x + delta.y * delta.y );
}

vec3 sphericalNormal( float radius, vec2 position, vec2 center ) {
	vec2 delta = position - center;
	float zSq = ( radius * radius - delta.x * delta.x - delta.y * delta.y );
	return normalize( vec3( delta, zSq ) );
}

void main( void ) {

	// Frag coord to corrected 0 to 1 coordinates with 0.5, 0.5 at center.
	float aspectRatio = resolution.x / resolution.y;
	vec2 position = 2.0 * ( ( gl_FragCoord.xy / resolution.xy ) - vec2( 0.5, 0.5 ) );
	position.x *= aspectRatio;
	
	// Center mouse.
	vec2 centeredMouse = 2.0 * ( mouse - vec2( 0.5, 0.5 ) );
	centeredMouse.x *= aspectRatio; 
	
	// Define 2 spheres.
	vec2 sphereCenter1 = vec2( 0.0, 0.0 );
	vec2 sphereCenter2 = vec2( centeredMouse.x, centeredMouse.y );
	
	// Evaluate contributions.
	float sphereContribution1 = metaballContribution( position, sphereCenter1 ) * ( 0.5 + 0.45 * sin( time ) );
	float sphereContribution2 = metaballContribution( position, sphereCenter2 );
	float totalContribution = sphereContribution1 + sphereContribution2;
	
	// Discard low contributions.
	if( totalContribution < 5.0 ) {
		discard;
	}
	
	// Evaluate normal as weighed sphere normals.
	float r = 0.6;
	vec3 n1 = sphericalNormal( r, position, vec2( 0.0 ) );
	vec3 n2 = sphericalNormal( r, position, centeredMouse );
	vec3 normal = normalize( ( n1 * sphereContribution1 + n2 * sphereContribution2 ) / totalContribution );
	
	// Apply simple lighting.
	vec3 view = normalize( vec3( 0.5 * cos( time ), 0.5 * sin( time ), 1.0 ) );
	float proj = dot( view, normal );
	
	// Out!
	gl_FragColor = vec4( vec3( proj ), 1.0 );
	//gl_FragColor = vec4( normal, 1.0 );
}