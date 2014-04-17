#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float randAliasing(vec2 p){

	p += .2127 + p.x * 0.1113 + p.y;
	vec2 r = 4.445 * sin((485.689) * (p));
	//r.x *= (time * 0.1);
	
	return fract(r.x * r.y);
	//return r.x * r.y;
}

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy);
	vec2 p = -1.0 + 2.0 * position;
	p.x *= resolution.x / resolution.y;
	
	//float r = randAliasing(vec2(28.0) * p.xy);
	float r = randAliasing(floor(vec2(128.0) * p.xy));
	r += 0.3;
	r *= 0.5;
	
	gl_FragColor = vec4(vec3(r), 1.0);
}