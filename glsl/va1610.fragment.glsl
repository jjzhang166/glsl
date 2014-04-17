#ifdef GL_ES
precision mediump float;
#endif

// Rhombille tiling by @ko_si_nus

uniform vec2 resolution;

const float TAN30 = 0.5773502691896256;
const float COS30 = 0.8660254037844387;
const float SIN30 = 0.5;
const float XPERIOD = 2.0 * COS30;
const float YPERIOD = 2.0 + 2.0 * SIN30;
const float HALFXPERIOD = XPERIOD / 2.0;
const float HALFYPERIOD = YPERIOD / 2.0;
const float SCALE = 10.0;

const float topColor = 0.8;
const float leftColor = 0.6;
const float rightColor = 0.4;

void main(void) {
	vec2 position = gl_FragCoord.xy / resolution.y * SCALE;

	float x;
	float y = mod(position.y, YPERIOD);
	if (y < HALFYPERIOD) {
		x = mod(position.x, XPERIOD);
	}
	else {
		x = mod(position.x + HALFXPERIOD, XPERIOD);
		y -= HALFYPERIOD;
	}

	float color, opp;
	if (x < COS30) {
		color = leftColor;
		opp = TAN30 * (COS30 - x);
	}
	else {
		color = rightColor;
		opp = TAN30 * (x - COS30);
	}
	if (y < opp || opp < y-1.0) {
		color = topColor;
	}

	gl_FragColor = vec4(color, color, color, 1.0);
}