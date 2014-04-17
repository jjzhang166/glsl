///  LAVA lamp... somehow ;-)  - Harley
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 c = vec4(0.3);
	float x = 10.;
	float y = 12.;
	//float m = 2.;  Use time ;-)
	c.x += cos(uv.x * y) - sin(uv.y * time);
	c.y += cos(uv.y * x) + cos(uv.x * time);

	gl_FragColor = vec4(c);

}