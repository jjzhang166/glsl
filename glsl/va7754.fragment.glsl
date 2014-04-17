#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define BEAMLENGTH 10.0
#define BASEBEAMWIDTH 1.0
#define STARCENTERSIZE 130.0

void main( void ) {

	vec2 starCenter = resolution / 2.;
	vec3 color = vec3(0.6,0.6,0.0);
	float CurrentDist = distance(starCenter, gl_FragCoord.xy);
	if(CurrentDist < STARCENTERSIZE)
	{
		float firstMod = (STARCENTERSIZE - CurrentDist) / STARCENTERSIZE;
		color = clamp((color + firstMod)*firstMod,0.,1.);
		gl_FragColor = vec4(color,0.0);
		
	}
}