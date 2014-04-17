#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float PI = 3.141592;
void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );

	float c = 0.0;
	float dx = uv.x - 0.5;
	float dy = uv.y - 0.5;
	c = (atan(dy, dx) / PI + 1.0) * 0.5;
	float t = (sin(time * 0.5) + 1.0) * 0.5;
	c = sin(c * PI * t * 45.0);
	gl_FragColor = vec4(c, c, c, 1.0 );

}