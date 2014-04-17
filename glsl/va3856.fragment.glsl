#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

		
	float red = sin(length( gl_FragCoord.xy)* (time * 0.2) );
	float green = 0.0;
	float blue = 0.0;
		
	
	gl_FragColor = vec4(red, green, blue, 1.0);

}