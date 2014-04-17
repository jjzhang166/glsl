// Zoom out

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float rand(vec2 coordinate) {
    return fract(sin(dot(coordinate.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 f(vec2 p) {
	p = abs(p);
	vec3 c1 = vec3(1.0);
	vec3 color = vec3(1.0);
	float res = 999.0;
	float s = 1.0;
	
	for (int i = 0; i < 100; i++) {
		res = min(res, distance(p, c1.xy) - c1.z+s);
		s += 1.0;
		p.x += -2.0+4.0*rand(vec2(s, 0))+sin(time-length(p/s/0.7));
		p.y += -2.0+4.0*rand(vec2(s, 0))+cos(time-length(p/s/0.7));
		p /= 2.0;
		color = min(color, normalize(hsv(abs(res), 1.0, 1.0))) + 0.1;
	}
	
	return color;
}

void main( void ) {

	vec2 position = surfacePosition;
	gl_FragColor = vec4( f(position), 1.0 );

}