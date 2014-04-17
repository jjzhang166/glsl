// schmid

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float saturate(float x) { return clamp(x, 0.0, 1.0); }
float svin(float p) { return sin(p*6.28) * 0.5 + 0.5; }
float square(float x) { return floor(mod(x, 2.0)); }
float r(vec2 v) { return sqrt(dot(v,v)); }
float a(vec2 v) { return atan(v.y,v.x) / 6.28; }
float a2(vec2 v) { return atan(v.y,v.x) / 6.28 * sin(v.x * 8.0); }

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	vec2 pc = pos * 2.0 - vec2(1.0, 1.0);
	
	float t = svin(time * 0.01);
	float x = square(pos.x * 1.0 + square(svin(pos.y * 111.0) * 2.6) * 33.5 + square(svin(pos.y * 97.0) * 1.1) * 7.3);
	float y = square(pos.x * 1.1 + square(svin(pos.y * 211.0) * 1.6) * 31.5 + square(svin(pos.y * 137.0) * 3.1) * 6.3);
	float z = square(pos.x * 1.3 + square(svin(pos.y * 147.0) * 6.6) * 38.5 + square(svin(pos.y * 93.0) * 2.1) * 5.3);
	gl_FragColor = vec4(x, y * 0.3, z * 0.1, 1.0 );
}