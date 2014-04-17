#ifdef GL_ES
precision mediump float;
#endif

// This should be the starting point of every effect - dist
// i have a fixation with lines - dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 SUN_1 = vec3(0.714,0.494,0.357);
vec3 SUN_2 = vec3(0.753,0.749,0.678);
vec3 SUN_3 = vec3(0.741,0.745,0.753);
vec3 SUN_4 = vec3(0.682,0.718,0.745);
	
void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy ) - 0.5) / vec2(resolution.y/resolution.x, 1.0);
	vec3 color = vec3(0.);
	float angle = atan(position.y,position.x);
	float d = length(position);
	
	color += 0.05/length(vec2(.04,2.*position.y+sin(position.x*4.+time*2.)))*SUN_1; // I'm sure there's an easier way to do this, this just happened to look nice and blurry.
	color += 0.05/length(vec2(.06,3.*position.y+sin(position.x*4.+time*3.)))*SUN_2;
	color += 0.05/length(vec2(.10,5.*position.y+sin(position.x*4.+time*5.)))*SUN_3;
	color += 0.05/length(vec2(.14,7.*position.y+sin(position.x*4.+time*7.)))*SUN_4;
	gl_FragColor = vec4(color, 1.0);
}