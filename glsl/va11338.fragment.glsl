#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {

	vec2 position = surfacePosition;//-1.0+2.0*( gl_FragCoord.xy / resolution.xy );

	vec4 c = vec4(1);
	vec2 p = position;
	float gr = (1.0+sqrt(5.0))/2.0;
	float s = 1.0;
	float S = sin(1.);
	float C = cos(1.);
	for (int i = 0; i < 15; i++) {
		p = vec2(p.x*p.x - p.y*p.y, 2.0*p.x*p.y)+mouse*2.0-1.0;
		p = vec2(p.x*C - p.y*S, p.y*C + p.x*S);
		s /= gr;
		p = abs(p);
		c += 1.0-length(p);
	}
	gl_FragColor = sin(c)*0.5+0.5;
}