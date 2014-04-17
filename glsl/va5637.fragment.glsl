#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution;

	vec3 col = vec3(0.2 - distance(pos, mouse));
	col.x += cos(time) * abs(sin(2.0*time+2.0))*0.2 + 0.2;
	col -= distance(pos, vec2(0.5,0.5)) * 0.2;

	gl_FragColor = vec4( clamp(col, 0.0, 1.0), 1.0 );
}