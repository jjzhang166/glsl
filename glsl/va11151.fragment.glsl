#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float Circle(vec2 p, vec2 a, float s) {
	p -= a;
	return step(length(p), s);
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.y);
	p.x -= 0.5*resolution.x/resolution.y;
	p.y -= 0.5;
	
	
	float c = 0.;
	c += Circle(mod(p, 0.05)-vec2((sin(time*4.))/32.+0.025, cos((time*4.))/32.+0.025), vec2(0, 0), 0.05);
	c = min(c, 0.4);
	gl_FragColor = vec4(c, c, c, 0.);

}