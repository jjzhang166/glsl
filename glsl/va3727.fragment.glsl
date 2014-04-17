#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 point = vec2(0, 0);
vec3 color = vec3(0.5, 0.7, 0.8);
vec2 offset = resolution.xy / 2.0;

void main( void ) {
	vec2 pos = (gl_FragCoord.xy - offset.xy);
	float f = 0.0;
	float t;
		
	for(int i = 0; i < 100; i++) {
		t = time-float(i)*0.02;
		vec2 pMod = vec2(sin(t+cos(t)), cos(t+sin(t))) * offset.xy * (0.2+sin(t/4.0));	
		f += (1.0 / (exp2(distance(point+pMod, pos)*0.2*float(i+1))));	
	}
	
	color = (color*f);
	gl_FragColor = vec4(color, 1.0);
}