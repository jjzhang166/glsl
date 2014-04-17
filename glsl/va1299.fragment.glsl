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
	float angle = atan(distanceVector.x, distanceVector.y);
	
	float scale = 0.0001;
	float distance = 1.0 - scale * ((distanceVector.x * distanceVector.x) + (distanceVector.y * distanceVector.y));

	float cogMin = 0.02; // 'min' is actually the outer edge because I'm using 1/distance... for reasons I can't remember :(
	float cogMax = 0.7; // 'max' is the inner edge, so this controls the size of the hole in the middle - the higher the value the smaller the hole

	// tooth adjust makes the teeth slope so they get smaller as they get further out
	float toothAdjust = 2.4 * (distance - cogMin);
	// 12 defines the number of cog teeth
	float angleFoo = sin(angle*12.0 - time * 4.0) - toothAdjust;
	cogMin += 20.0 * clamp(1.0 * (angleFoo + 0.2), 0.0, 0.015); // add 0.2 to make teeth a bit thinner, the 0.015 clamp controls the thickness of the cog ring
	
	// By multiplying values up and clamping we can get a solid cog with slight anti-aliasing
	float isSolid = clamp(2.0 * (distance - cogMin) / cogMax, 0.0, 1.0);
	isSolid = clamp(isSolid * 100.0 * (cogMax - distance), 0.0, 1.0);
	
	// Make it BlitzTech purple
	gl_FragColor = vec4(0.5 * isSolid, 0.25 * isSolid, 0.5 * isSolid, 1.0);
}