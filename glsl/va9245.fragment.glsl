#ifdef GL_ES
precision lowp float;
#endif

uniform vec2  resolution;
uniform float time;

const int   complexity =4;
const float wavelength = 1.;

void main() {
	vec2 p=(1.0*gl_FragCoord.xy-resolution) / max(resolution.x,resolution.y);
	for(int i = 1; i < complexity; i++) {
		float phase = time / wavelength;
		float fi = float(i);
		p = vec2(
			p.x + fi*cos(fi*p.y+ phase),
			p.y + fi*sin(fi*p.x+ phase)
		);
	}
	gl_FragColor = vec4(1. - (sin(p.x*p.y)/8.+0.8));
}