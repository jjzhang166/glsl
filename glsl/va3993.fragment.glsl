#ifdef GL_ES
precision mediump float;
#endif

//wut

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	gl_FragColor = vec4(vec3(sin(1.0 - length((sin(time * 1000.0)) - position))) * 0.6, 1.0);

}