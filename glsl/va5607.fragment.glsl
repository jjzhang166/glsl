#ifdef GL_ES
precision mediump float;
#endif

// blame @Flexi23

uniform float time;
uniform vec2 resolution;

float spade(vec2 uv){
	return abs(uv.x) + abs(uv.y);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

void main( void ) {

	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = 0.5 + ( gl_FragCoord.xy / resolution - 0.5)*aspect;


	gl_FragColor = vec4(mix(float(mod(spade(uv-0.5)*32. - time*2.,1.) > 0.5),
				float(mod(spade(uv-0.5)*32. + time*4.,1.) > 0.5),
				sigmoid(512.*(length(uv-0.5) - 0.125))));
}