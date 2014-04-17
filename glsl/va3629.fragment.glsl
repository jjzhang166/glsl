// loading bar. psonice.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - .5;
	
	float p = (abs(position.x) < 0.45) && (abs(position.y) < .04) ? 1. : 0.;
	p = (abs(position.x) < .445) && (abs(position.y) < .035) ? 0. : p;
	position.x += .44;
	float t = time * 0.1;
	t = (t>0.3) && (t<0.4) ? floor(t*10.)*.1 : t;
	p = (position.x > 0.) && (position.x < .88) && (t > position.x) && (abs(position.y) < .03) ? 1. : p;
	gl_FragColor = vec4(p);
}