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

float AMDLogo(vec2 p) {
	
	float y = floor((0.5-p.y)*60.);
	if(y < 0. || y > 4.) return 0.;

	float x = floor((0.9-p.x)*60.)-2.;
	if(x < 0. || x > 14.) return 0.;
		
	float v = 0.0;
	// read the BIN upside down and you got the letters...
	v = mix(v, 18990.0, step(y, 7.5)); //100101000101110
	v = mix(v, 18985.0, step(y, 3.5)); //100101000101001
	v = mix(v, 31401.0, step(y, 2.7)); //111101010101001 
	v = mix(v, 19305.0, step(y, 1.5)); //100101101101001
	v = mix(v, 12846.0, step(y, 0.0)); //011001000101110
	
	return floor(mod(v/pow(2.,x), 2.0));
}

void main( void ) {

	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = 0.5 + ( gl_FragCoord.xy / resolution - 0.5)*aspect;


	gl_FragColor = vec4(mix(float(mod(spade(uv-0.5)*32. - time*2.,1.) > 0.5),
				float(mod(spade(uv-0.5)*32. + time*4.,1.) > 0.5),
				sigmoid(512.*(length(uv-0.5) - 0.125))));
	vec2 c = vec2(0.242,-0.04);
	uv = 0.5 + (uv-0.5)*12.;
	gl_FragColor = mix(gl_FragColor, 1.-gl_FragColor, AMDLogo( c + uv));
}