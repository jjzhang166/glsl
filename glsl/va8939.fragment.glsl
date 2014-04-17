// by @301z
// based on http://devmaster.net/forums/topic/4648-fast-and-accurate-sinecosine/

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const float Pi = 3.14159;

float sinApprox(float x) {
    x = Pi + (2.0 * Pi) * float(int((x / (2.0 * Pi)))) - x;
    return (4.0 / Pi) * x - (4.0 / Pi / Pi) * x * (x < 0.0 ? -x : x);
}

float cosApprox(float x) {
    return sinApprox(x + 0.5 * Pi);
}

float cosSx(float x) {
    return  sinApprox(x);
}

void main() {
	vec3 c = vec3 (1.);
	float a = time * 2.;
	if (distance (vec2(cosApprox(a), sinApprox(a))*0.2, gl_FragCoord.xy/resolution.xy-vec2(0.5)) < 0.1) {
		c = vec3(0.);
	}
	gl_FragColor = vec4 (c, 1.);
    
}
