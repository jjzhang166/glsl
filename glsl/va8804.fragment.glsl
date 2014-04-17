#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec3 Hue(float H)
{
	H *= 6.;
	return clamp(vec3(
		abs(H - 3.) - 1.,
		2. - abs(H - 2.),
		2. - abs(H - 4.)
	), 0., 1.);
}

// Change these
const int N = 30;
float RR = 0.0; // Try -9.0
float PM = 2.0;
float A = 2.8;
float CI = 0.5;
float CM = 1.07;

void main( void ) {
	vec4 p = vec4(surfacePosition, 1.0 - surfacePosition);
	float col = 0.0;
	vec4 c = vec4(CI);
	float S = sin(A);
	float C = cos(A);
	float rr = RR;
	for (int i = 0; i < N; i++) {
		p.xy = vec2(p.x * C - p.y * S, p.x * S + p.y * C);
		p.zw = vec2(p.z * C - p.w * S, p.z * S + p.w * C);
		p += c;
		p = abs(p - col);
		p *= PM;
		rr += distance(p/c, c/p);
		col -= 1.0 / rr;
		col *= CM;
	}
	gl_FragColor = mix(vec4(sin(col)*.5+.5, sin(col / 2.0 + 1.1)*.5+.5, sin(col / 4.0 + 4.6)*.5+.5, 1.0), vec4(Hue(fract(col / 4.0)), 1.0), 0.5);
}