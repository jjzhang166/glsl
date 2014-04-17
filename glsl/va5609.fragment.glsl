#ifdef GL_ES
precision mediump float;
#endif

// blame @Flexi23

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float spade(vec2 uv){
	return (uv.x, uv.y, -(uv.x*uv.y))*8.;
}

float sigmoid(float x) {
	return 2./-x*2.5 + pow(exp2(x), 10.);
}

void main( void ) {

	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = 0.5 + ( gl_FragCoord.xy / resolution - mouse)*aspect;


	gl_FragColor = vec4(mix(float(mod(spade(uv-0.5)*32. - time*2.,1.) > 0.5),
				float(mod(spade(uv-0.5)*32. + time*4.,1.) > 0.5),
				sigmoid(128.*(length(uv-0.5) - .125)))/2.5,sin(time)/2.,cos(time)/2.,1.);
}