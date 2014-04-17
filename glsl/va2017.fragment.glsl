#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 color;
	
	color = vec3(sin(time * 1000.0));
	
	color.r *= sin(time * 1000.0);
	color.g *= cos(time * 2000.0);
	color.b *= cos(time * 5000.3);
	
	
	gl_FragColor = vec4(color, 1.0 );

}