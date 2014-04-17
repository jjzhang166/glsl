#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec4 pixel = vec4(0.0, 0.0, 0.0, 1.0);
	

	pixel.x = distance(gl_FragCoord.xy, mouse.xy)/100.0;
	
	gl_FragColor = pixel;

}