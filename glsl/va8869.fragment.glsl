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

const int N =20;

float wave(float x) {
	return 0.1 - 0.5 * cos(x);	
}

void main( void ) {
	vec2 p = surfacePosition;
	float col = 0.0;
	vec4 c = abs(vec4(wave(time*0.18934), wave(time*0.124532), wave(time*0.28934), wave(time*0.214532)));
	c += abs(vec4(p.xy, length(p), dot(p, p)));
	float S = sin(time*0.1);
	float C = cos(time*0.1);
	for (int i = 0; i < N; i++) {
		c.xy = vec2(c.x * C - c.y * S, c.x * S + c.y * C) * 1.2 + vec2(2.0, 0.5);
		c.zw = vec2(c.z * C - c.w * S, c.z * S + c.w * C) * 1.1 + vec2(3.0, 1.0);
		c = abs(c - c.wxzy - c.zywx);
		col += abs(dot(c, c.wzyx) - length(c));
		//c += p.xyyx;
		
	}
	gl_FragColor = vec4(Hue(fract(log(pow(col,mod(tan(time*10.),1.0/10.)*0.7)))), 1.) ;
}