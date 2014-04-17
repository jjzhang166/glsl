#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy - vec2(0.5);
	
	float len = smoothstep(0., 0.8, length(position));
	vec3 color = vec3(1,0,0);
	
	gl_FragColor = vec4( 1. - len );
	gl_FragColor.rgb *= color;
}