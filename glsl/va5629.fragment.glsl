#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846264

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 seed){
    return abs(fract(sin(dot(seed.xy ,vec2(12.9898,78.233))) * 43758.5453));
}

void main( void ) {

	vec2 off = gl_FragCoord.xy/resolution;
	off.x = abs(off.x - 0.5);
	
	float scale = 1.0 - cos(off.x * PI);
	gl_FragColor = vec4(0.1*scale, 0.1*scale, 0.12*scale, 1.0);
	
	float slip = fract(time + 0.02*off.y);
	
	if (slip > 0.5 && off.x < 0.033)
		gl_FragColor.xy += 0.7;
	
	if (rand(off + slip) > 0.8)
		gl_FragColor.xyz *= 1.2;
}