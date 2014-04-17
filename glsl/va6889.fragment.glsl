#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float scale = 30.0;
const float huePhase = 0.0;
const float N = 7.;
const float interferenceAngle = 0.5/N;

const float PI = 3.1416;

bool isOdd(int v) {
    float dividend = float(v) / 2.0;
    return dividend != floor(dividend);
}
vec4 hsvToRgb(vec4 hsv) {
    float h = hsv.r*6.;
    float s = hsv.g;
    float v = hsv.b;
    int i = int(floor(h));
    float f = isOdd(i) ? h - float(i) : 1.0 - (h - float(i));
    float m = v * (1.0 - s);
    float n = v * (1.0 - s * f);
    vec4 result = (i == 0) ? vec4(v, n, m, hsv.a) : ((i == 1) ?
        vec4(n, v, m, hsv.a) : ((i == 2) ? vec4(m, v, n, hsv.a) : ((i == 3) ?
        vec4(m, n, v, hsv.a) : ((i == 4) ? vec4(n, m, v, hsv.a) : ((i == 5) ?
        vec4(v, m, n, hsv.a) : vec4(v, n, m, hsv.a))))));
    
    return result;
}
 
 
// triangle wave from 0 to 1
float wrap(float n) {
	return abs(mod(n, 2.)-1.)*-1. + 1.;
}
 
// creates a cosine wave in the plane at a given angle
float wave(float angle, vec2 point) {
	float cth = cos(angle);
	float sth = sin(angle);
	return (cos (cth*point.x + sth*point.y) + 1.) / 2.;
}
 
// sum 7 cosine waves at various interfering angles
// wrap values when they exceed 1
float quasi(float interferenceAngle, vec2 point) {
	float sum = 0.;
	for (float i = 0.; i < N; i++) {
		sum += wave(PI*i*interferenceAngle, point);
	}
	return wrap(sum);
}
 
void main() {
	vec2 position = (gl_FragCoord.xy - resolution.xy / 2.) / resolution.y * scale;
	float brightness = quasi(time * 0.02, position);
//	gl_FragColor = hsvToRgb(vec4(mod(brightness+huePhase, 0.5)*2., 1, 1, 1));
	gl_FragColor = hsvToRgb(vec4(mod(time * 0.02, 1.), 1., brightness, 1.));

}
