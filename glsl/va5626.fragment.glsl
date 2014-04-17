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
	vec2 position = gl_FragCoord.xy;
	vec2 aspect = vec2(1.,resolution.y/resolution.x );
	position -= 0.5*resolution;
	vec2 position2 = 0.5 + (position-0.5)/resolution*2.*aspect;
	float filter = sigmoid(pow(2.,7.5)*(length((position/resolution-mouse + 0.5)*aspect) - 0.015))*0.5 +0.5;
	position -= (mouse-0.5)*resolution;
	position = mix(position, position2, filter) - 0.5;
	
	
	vec3 light_color = vec3(1.2,0.8,0.6);
	
	float t = time*2.0;
//	vec2 position = ( gl_FragCoord.xy -  resolution.xy*.5 ) / resolution.x;

	// 256 angle steps
	float angle = atan(position.y,position.x)/(2.*3.14159265359);
	angle -= floor(angle);
	float rad = length(position);
	
	float color = 0.0;
	for (int i = 0; i < 1; i++) {
		float angleFract = fract(angle*256.);
		float angleRnd = floor(angle*256.)+1.;
		float angleRnd1 = fract(angleRnd*fract(angleRnd*.7235)*45.1);
		float angleRnd2 = fract(angleRnd*fract(angleRnd*.82657)*13.724);
		float t = t+angleRnd1*10.;
		float radDist = sqrt(angleRnd2+float(i));
		
		float adist = radDist/rad*.1;
		float dist = (t*.1+adist);
		dist = abs(fract(dist)-.5);
		color +=  (1.0 / (dist))*cos(0.7*(sin(t)))*adist/radDist/30.0;

		angle = fract(angle+.61);
	}
	
	
	gl_FragColor = vec4(color,color,color,1.0)*vec4(light_color,1.0);
}