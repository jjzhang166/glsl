#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 color = vec3(0, 0, 1.0);
	
	color *= (gl_FragCoord.x) * 0.005;
	color *= (resolution.x-gl_FragCoord.x) * 0.0025;
	
	color *= (gl_FragCoord.y) * 0.05;
	color *= (resolution.y-gl_FragCoord.y) * 0.0025;
	
	gl_FragColor = vec4(color, 1.0);

}