#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy);
	float d = sqrt((position.x - mouse.x)*(position.x - mouse.x)+(position.y - mouse.y)*(position.y - mouse.y));
	bool cond = d < 0.05;
	gl_FragColor = vec4(sin(d * 20.0 + time / 6.0), sin(d * 20.0 + time / 2.0), sin(d * 20.0 + time * 2.0), 1.0 );
}