#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//beautiful colours at their own..

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	gl_FragColor = vec4( vec3(p.y * 0.96, p.y + 0.33 + p.x * 0.5 -0.06, p.y + 0.66 -(1.0 - p.x) * 0.2 + sin(time) * 0.2) * (1.0 - distance(p, vec2(0.5))), 1.0 );

}