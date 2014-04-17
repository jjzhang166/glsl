#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 distanceVector = (gl_FragCoord.xy / resolution.xy) - mouse;
	distanceVector.x *= resolution.x;
	distanceVector.y *= resolution.y;
	float angle = atan(distanceVector.x, distanceVector.y)+time;
	
	// 12 defines the number of cog teeth
	float angleFoo = cos(angle*10.0);
	
	float isSolid = clamp(angleFoo * 100.0, 0.95, 1.0);
	
	// Make it BlitzTech purple
	gl_FragColor = vec4(78.0/255.0 * isSolid, 144.0/255.0 * isSolid, 8.0/255.0 * isSolid, 1.0);
}