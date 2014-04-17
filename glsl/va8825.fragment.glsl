#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265359

vec2 polarRepeat(vec2 p, float repeat) {
    float a = atan(p.y, p.x)*repeat + PI*0.5;// + PI*0.5;
    return length(p) * (vec2(sin(a),cos(a)));
}

float tire(vec2 p) {
	float repeat = floor(fract(time/10.0)*10.0)+1.0;
	
	p = polarRepeat(p, repeat);// * (PI/180.0));
	float d = dot(p,vec2(1.0,0.0));
	return d;//return d>0.2 ? 0.0 : 1.0;
}

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;
	p = p * 2.0 - 1.0;
	p.x *= resolution.x/resolution.y;

	vec3 colour = 1.0-vec3(pow(tire(p),2.0))*0.33;
	gl_FragColor = vec4( colour, 1.0 );

}