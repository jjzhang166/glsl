#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float dist = cos(-time*5.0 + gl_FragCoord.x/40.0)*40.0 + gl_FragCoord.x * 0.3;
	float diff = gl_FragCoord.y - (resolution.y / 4.5) - dist;
	vec3 color = vec3(0,0,smoothstep(1.3, 2.6, 4.0-abs(diff)));
	gl_FragColor = vec4( color, 1.0 );

}