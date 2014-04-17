#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	// zero to one
	float size = mouse.y;
	
	// normalize position
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	// background color
	vec3 base = vec3(0.2,0.2,0.2);
	
	// start glow amount at zero
	float glow = 0.;
	
	// cache some math
	float oneMinusSize = 1. - size;
	float invSize = 1./size;
	
	// right edge
	glow += clamp(position.x - oneMinusSize, 0., 1.) * invSize;
	
	// left edge
	glow += clamp((1. - position.x) - oneMinusSize, 0., 1.) * invSize;
	
	// top edge
	glow += clamp(position.y - oneMinusSize, 0., 1.) * invSize;
	
	// bottom edge
	glow += clamp((1. - position.y) - oneMinusSize, 0., 1.) * invSize;
	
	// Color to glow
	vec3 glowColor = vec3(1., 0., 0.);
	
	// compute final color
	gl_FragColor = vec4( vec3( base + glowColor * glow ), 1.0 );

}