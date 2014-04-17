#ifdef GL_ES
precision mediump float;
#endif

// 0.5 resolution works nicely
// #5093.2 and this by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define BLADES .0
#define BIAS 0.5
#define SHARPNESS 4.0
#define COLOR 0.54, 0.96, 0.72
#define BG 0.0, 0.0, 0.0

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy ) - vec2(0.5)) / vec2(resolution.y/resolution.x,1.0);
	vec3 color = vec3(0.);
	
	float angle = atan(-position.y,position.x);
	float dist = distance(position,vec2(0.));
	
	float blade = 1.-asin(0.5+0.5*cos(8.*angle))*(0.5+0.5*cos(angle+3.14/2.))/dist*0.4; // old classic =D
	
	color = mix(vec3(COLOR), vec3(BG), blade);
	
	gl_FragColor = vec4( color, 1.0 );

}