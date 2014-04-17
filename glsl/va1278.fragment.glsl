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
	
	float scale = 0.008;
	
	float angle = atan(distanceVector.x, distanceVector.y);
	
	float distance = 0.7 - scale * sqrt((distanceVector.x * distanceVector.x) + (distanceVector.y * distanceVector.y));

	float cogMin = 0.22; // 'min' is actually the outer edge because I'm using 1/distance... for reasons I can't remember :(
	float cogMax = 0.6; // 'max' is the inner edge, so this controls the size of the hole in the middle - the higher the value the smaller the hole

	// tooth adjust makes the teeth slope so they get smaller as they get further out
	float toothAdjust = 5.0 * (distance - cogMin);
	// 12 defines the number of cog teeth
	float angleFoo = sin(angle*07.0 - time * 10.0) - toothAdjust;
	cogMin += clamp(1.0 * (angleFoo + 0.1), 0.0, 0.25); // add 0.2 to make teeth a bit thinner, the 0.15 clamp controls the thickness of the cog ring
	
	// By multiplying values up and clamping we can get a solid cog with slight anti-aliasing
	float isSolid = clamp(2.0 * (distance - cogMin) / cogMax, 0.0, 1.0);
	isSolid = clamp(isSolid * 100.0 * (cogMax - distance), 0.0, 1.0);
	
	// Make it BlitzTech purple
	gl_FragColor = vec4(0.5 * isSolid, 0.15 * isSolid, 2.5 * isSolid, 0.1);
}