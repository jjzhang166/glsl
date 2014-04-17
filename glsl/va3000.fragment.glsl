// @rotwang @mod* color, @mod- mouse, @mod+ resolution independent
// ...and modified to funny ring with clamps

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = (gl_FragCoord.xy / resolution.xy);
	vec2 bipos = unipos*2.0-1.0;
	bipos.x *= aspect;

	float angle = atan(bipos.x, bipos.y);
	
	float scale = 0.2;
	//float distance = 1.0 - scale * ((distanceVector.x * distanceVector.x) + (distanceVector.y * distanceVector.y));

	float distance = (1.0 - length(bipos)) * scale;
	
	float cogMin = 0.01+0.01*sin(time); // 'min' is actually the outer edge because I'm using 1/distance... for reasons I can't remember :(
	float cogMax = 0.05; // 'max' is the inner edge, so this controls the size of the hole in the middle - the higher the value the smaller the hole

	// tooth adjust makes the teeth slope so they get smaller as they get further out
	float toothAdjust = 2.4 * (distance - cogMin);
	// 12 defines the number of cog teeth
	float angleFoo = sin(angle*24.0 - time * 4.0) - toothAdjust;
	cogMin += 1.5 * clamp(1.0 * (angleFoo + 0.5), 0.0, 0.01); // add 0.2 to make teeth a bit thinner, the 0.015 clamp controls the thickness of the cog ring
	
	// By multiplying values up and clamping we can get a solid cog with slight anti-aliasing
	float isSolid = clamp(2.0 * (distance - cogMin) / cogMax, 0.0, 1.0);
	isSolid = clamp(isSolid * 50.0 * (cogMax - distance), 0.0, 1.0);
	
	
	float hue = 0.56;
	float sat = 0.6;
	float lum = isSolid * length(bipos*0.25)*8.0;
	vec3 rgb = hsv2rgb(hue, sat, lum);
	
	gl_FragColor = vec4(rgb, 1.0);
}