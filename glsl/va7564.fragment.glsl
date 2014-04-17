#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.141592;
vec2 adjustAspectRatio( vec2 v) {
	return v * vec2(resolution.x / resolution.y, 1.0) + vec2(-resolution.y / resolution.x * 0.5, 0.0);
}

void main( void ) {
	vec2 position = adjustAspectRatio( gl_FragCoord.xy / resolution.xy );
	float c, over = 1.3;
	float d0 = distance(position.xy, adjustAspectRatio(1.-mouse));
	float d1 = distance(position.xy, adjustAspectRatio(mouse));
	c = (sin(d0 * PI * 20.0) + sin(d1 * PI * 20.0))/2.;

	gl_FragColor = vec4(c*3.*over - 1., c*3.*over - 0., c*3.*over - 2., 1.0 );

}