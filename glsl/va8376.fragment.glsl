#ifdef GL_ES
precision lowp float;
#endif

uniform vec2  resolution;
uniform float time;

const int   complexity = 2;
const float wavelength = 2.;

void main() {
	vec2 p=(2.0*gl_FragCoord.xy-resolution) / max(resolution.x,resolution.y);
	for(int i = 1; i < complexity; i++) {
		float phase = time / wavelength;
		p = vec2(
			p.x + float(i)*sin(float(i)*p.y+phase*float(i)),
			p.y + float(i)*sin(float(i)*p.x+phase*float(i))
		);
	}
	float l = 1. - (sin(p.x*p.y)/8.+0.9);
	gl_FragColor = vec4(l,l,l,1);
}
