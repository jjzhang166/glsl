// schmid

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float saturate(float x) { return clamp(x, 0.0, 1.0); }
float svin(float p) { return sin(p*6.28) * 0.5 + 0.5; }
float r(vec2 v) { return sqrt(dot(v,v)); }
float a(vec2 v) { return atan(v.y,v.x) / 6.28; }
float a2(vec2 v) { return atan(v.y,v.x) / 6.28 * sin(v.x * 8.0); }

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	vec2 pc = pos * 2.0 - vec2(1.0, 1.0);
	float t = svin(time * 0.001);
	float x = 1.0-smoothstep(0.0, 1.0, r(pc) * 1.7 + svin(a2(pc) * 6.0 + t * 3.0) - svin(a2(pc) * 4.0 + 7.0) + t*1.1);
	float y = 1.0-smoothstep(0.0, 1.0, r(pc) * 1.8 + svin(a2(pc) * 5.7 + t * 7.1) - svin(a2(pc) * 9.0 + 3.0) + t*1.2);
	float z = 1.0-smoothstep(0.0, 1.0, r(pc) * 1.9 + svin(a2(pc) * 3.0 + t * 4.3) - svin(a2(pc) * 22.0) + t*1.3);
	gl_FragColor = vec4(y+z, (x+y) * 0.4, (z+x) * 0.1, 1.0 );
}
