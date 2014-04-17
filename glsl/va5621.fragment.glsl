#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}


void main( void ) {
	float c1 = 10.939;
	vec2 position = gl_FragCoord.xy;
	position -= 0.5*resolution;
	vec2 mouse2 = mouse/resolution;
	vec2 position2 = 0.5 + (position-0.5)/c1;
	float filter1 = sigmoid(pow(2.,6.)*(length(((position-(mouse-0.5)*resolution)/resolution.y))-0.12))*0.5 +0.5;
	float filter2 = sigmoid(pow(2.,10.)*(length((position/resolution-mouse + 0.5)*vec2(1.,resolution.y/resolution.x ))-0.05585))*0.5 +0.5;
	position *= c1;
	position = mix(position, position2, filter2);
	//position = position2;
	

	float color = 0.0;

	color += cos(sin(distance(position* resolution.xy, vec2(0.))*0.75+time*2.));
	color = mix( 1.-color, color, 1.-filter1);

	gl_FragColor = vec4( vec3( color ), 1.0 );

}