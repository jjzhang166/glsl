#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const vec4 yellow = vec4(1.0,1.0,0.0,1.0);
const vec4 black = vec4(0.0,0.0,0.0,1.0);

vec2 center = resolution.xy*0.5;
float radius = min(resolution.x,resolution.y)*0.25;

float pow2(float value) {
	return pow(value,2.0);
}

bool insidePac(vec2 vec) {
	//Circle equation: (x-cx)^2+(y-cy)^2=r^2
	return pow2(vec.x-center.x) + pow2(vec.y - center.y) < pow2(radius);
}

void main( void ) {
	//vec2 center = vec2(resolution.x/2.0,resolution.y/2.0)
	if (insidePac(gl_FragCoord.xy)){
		gl_FragColor = yellow;
	} else {
		gl_FragColor = black;
	}

	
}