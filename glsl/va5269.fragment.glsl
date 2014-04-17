#ifdef GL_ES
precision mediump float;
#endif
 
#define CIR_DENSITY 2.5
 
#define R_SHIFT 0.9
#define G_SHIFT 0.8
#define B_SHIFT 0.7
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 
float bubble(vec2 pos, float shift) {
	float shift1 = sin(time/5.0*shift);
	float shift2 = cos(time/2.0*shift);
	
	float p1 = distance(gl_FragCoord.xy,pos.xy);
	float p2 = cos(distance(gl_FragCoord.xy*(shift1-shift2), pos.xy*(shift1-shift2))/CIR_DENSITY*mouse.x+mouse.y);
	
	return (1.5-smoothstep(255.0, shift1, p1))*p2;
}
 
void main( void ) {
 
	vec2 position = vec2(resolution.x*mouse.x, resolution.y*mouse.y);
	
	float colR = bubble(position, R_SHIFT);
	float colG = bubble(position, G_SHIFT);
	float colB = bubble(position, B_SHIFT);
	
	gl_FragColor = vec4( vec3( colR, colG, colB), 1.0 );
}
