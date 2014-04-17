#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// http://en.wikipedia.org/wiki/HSL_and_HSV#From_HSL
vec3 hsl2rgb(in float hue, in float sat, in float lum) {
	float chroma = (1.0 - abs(2.0 * lum - 1.0)) * sat;
	float huep = hue / 60.0;
	float X = chroma * (1.0 - abs(mod(huep, 2.0) - 1.0));
	float r = 0.0, g = 0.0, b = 0.0;

	if (huep < 1.0) {
		r = chroma; g = X;
	} else if (huep < 2.0) {
		r = X; g = chroma;
	} else if (huep < 3.0) {
		g = chroma; b = X;
	} else if (huep < 4.0) {
		g = X; b = chroma;
	} else if (huep < 5.0) {
		r = X; b = chroma;
	} else if (huep < 6.0) {
		r = chroma; b = X;
	}
	
	float m = lum - 0.5 * chroma;
	
	return vec3(r + m, g + m, b + m);
}

void main( void ) {

	float hue = mod(time * 10.0, 360.0);
	float sat = 0.7;
	float lum = 0.6;
	vec3 rgb = hsl2rgb(hue, sat, lum);

	gl_FragColor = vec4( rgb, 1.0 );
}