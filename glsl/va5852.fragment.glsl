// @author germangb

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
float seed = 2.0;
float random () {
	seed = mod((13821.0 * seed), 32768.0);
	return mod(seed, 2.0)+1.0;
}

void main( void ) {

	vec2 pixel_pos = gl_FragCoord.xy;
	vec3 color1 = vec3(0.7, 0.25, 2.25*sin(time));
	vec3 color2 = vec3(0.25, 0.7, 0.5*cos(time));
	vec3 color3 = vec3(0.5*sin(time), 0.25, 0.7);
	
	vec3 final_color = vec3(0.05*cos(time), 0.025*cos(time*0.5), 0.05*sin(time));
	for (int i = 0; i < 9; ++i) {
		vec3 light_color = vec3(0.2,0.1,0.1);
	
	vec2 position = ( gl_FragCoord.xy -  resolution.xy*.5 ) / resolution.x;
	float angle = fract(atan(position.y,position.x)/(2.*3.14159265359));

	float angleFract = fract(angle*256.);
	float angleRnd = floor(angle*256.)+1.;
	float angleRnd1 = fract(angleRnd*fract(angleRnd*.7235)*45.1);
	float angleRnd2 = fract(angleRnd*fract(angleRnd*.82657)*13.724);
	float t = time*20.0+angleRnd1*10.;
	float radDist = sqrt(angleRnd2);
	
	float adist = radDist/length(position)*.1;
	float dist = abs(fract(t*.1+adist)-.5);
	float color =  (1.0 / (dist))*cos(0.7*(sin(t)))*adist/radDist/30.0;
	}
}