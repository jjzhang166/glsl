#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 c = vec4(0.0);
	float x = 10.;
	float y = 10.;
	float m = 32.;
	c.x += cos(uv.x * m) - sin(uv.y * m);
	c.y += cos(uv.y * m) + cos(uv.x * m);

	gl_FragColor = vec4(c);

}