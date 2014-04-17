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
	float x = abs(square(pc.x * 16.0 + r(pc + vec2(t,t))) - square(pc.y * 10.0 + r(pc + vec2(t,t))));
	gl_FragColor = vec4(x, 0.0, 0.0, 1.0 );
}
